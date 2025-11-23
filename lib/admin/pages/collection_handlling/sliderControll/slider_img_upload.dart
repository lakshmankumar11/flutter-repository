import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controller/image_controller.dart';

class SliderImgUploadHandling extends StatefulWidget {
  const SliderImgUploadHandling({super.key});

  @override
  State<SliderImgUploadHandling> createState() => _SliderImgUploadHandlingState();
}

class _SliderImgUploadHandlingState extends State<SliderImgUploadHandling> {
  final ImageController controller = Get.put(ImageController());

  File? _selectedImageFile;
  Uint8List? _webImageBytes;
  String? _webImageName;
  bool _uploading = false;
  String? _editImageId;

  @override
  void initState() {
    super.initState();
    controller.fetchImages();
  }

  Future<void> _pickImage({String? imageId}) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _editImageId = imageId;
      });

      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _webImageName = picked.name;
        });
      } else {
        setState(() {
          _selectedImageFile = File(picked.path);
        });
      }
    }
  }

  Future<void> _uploadOrUpdateImage() async {
    if (!kIsWeb && _selectedImageFile == null) return;
    if (kIsWeb && _webImageBytes == null) return;

    setState(() => _uploading = true);
    bool success;

    if (_editImageId != null) {
      success = await controller.updateImage(
        imageId: _editImageId!,
        file: _selectedImageFile,
        bytes: _webImageBytes,
        fileName: _webImageName,
      );
    } else {
      success = await controller.uploadImage(
        file: _selectedImageFile,
        bytes: _webImageBytes,
        fileName: _webImageName,
      );
    }

    setState(() {
      _uploading = false;
      _selectedImageFile = null;
      _webImageBytes = null;
      _webImageName = null;
      _editImageId = null;
    });

    await controller.fetchImages();
    Get.snackbar(
      success ? "Success" : "Failed",
      success
          ? (_editImageId != null ? "Image updated!" : "Image uploaded!")
          : "Operation failed",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _confirmDelete(String imageId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Image"),
        content: const Text("Are you sure you want to delete this image?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await controller.deleteImage(imageId);
      if (success) {
        await controller.fetchImages();
        Get.snackbar("Image Deleted", "Image deleted and list refreshed",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        Get.snackbar("Delete Failed", "Could not delete image",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Widget _buildImagePreview() {
    if (_selectedImageFile != null && !kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_selectedImageFile!, height: 180, fit: BoxFit.cover),
      );
    } else if (_webImageBytes != null && kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(_webImageBytes!, height: 180, fit: BoxFit.cover),
      );
    } else {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Center(
          child: Text(
            'No Image Selected\nTap Choose Image',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Uploaded Slider Images',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...controller.images.map((img) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    img.imageUrl.split('/').last,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text('Group ID: ${img.groupId}', style: const TextStyle(fontSize: 10)),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      // Uncomment to enable edit
                      // IconButton(
                      //   icon: const Icon(Icons.edit, color: Colors.amber),
                      //   onPressed: () => _pickImage(imageId: img.id),
                      // ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(img.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.blueGrey[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildImagePreview(),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Choose Image'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _pickImage(),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_upload),
                          label: _uploading
                              ? const Text('Uploading...')
                              : Text(_editImageId != null ? 'Update' : 'Upload'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _editImageId != null ? Colors.orange : Colors.indigo,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: !_uploading &&
                                  ((!kIsWeb && _selectedImageFile != null) ||
                                      (kIsWeb && _webImageBytes != null))
                              ? _uploadOrUpdateImage
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
