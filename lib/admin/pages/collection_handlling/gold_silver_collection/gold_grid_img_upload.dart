import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../adminApis/controllers/gold_collection_controller.dart';
import '../../../adminApis/models/gold_collection_model.dart';

class AdminGoldGridPage extends StatefulWidget {
  const AdminGoldGridPage({super.key});

  @override
  State<AdminGoldGridPage> createState() => _AdminGoldGridPageState();
}

class _AdminGoldGridPageState extends State<AdminGoldGridPage> {
  final controller = Get.put(CollectionController());

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  Future<void> showAddOrEditDialog({Collection? existing}) async {
    titleCtrl.text = existing?.title ?? '';
    descCtrl.text = existing?.description ?? '';
    XFile? pickedImage;
    Uint8List? imageBytes;
    bool isEditing = existing != null;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEditing ? "Edit Collection" : "Add New Collection"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (pickedImage != null)
                    kIsWeb
                        ? (imageBytes != null
                              ? Image.memory(
                                  imageBytes!, // ✅ null-checked
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const CircularProgressIndicator())
                        : Image.file(
                            File(pickedImage!.path), // ✅ null-checked
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                  else if (isEditing)
                    Image.network(
                      existing!.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  else
                    const Text("No image selected"),

                  TextButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Select Image"),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final img = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (img != null) {
                        final bytes = kIsWeb ? await img.readAsBytes() : null;
                        setState(() {
                          pickedImage = img;
                          imageBytes = bytes;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty ||
                      descCtrl.text.trim().isEmpty) {
                    Get.snackbar('Error', 'Title and description are required');
                    return;
                  }

                  if (!isEditing && pickedImage == null) {
                    Get.snackbar('Error', 'Please select an image');
                    return;
                  }

                  if (isEditing) {
                    await controller.updateCollectionWithImage(
                      id: existing!.id,
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      filePath: pickedImage?.path,
                      fileBytes: kIsWeb ? imageBytes : null,
                    );
                  } else {
                    await controller.addCollectionWithImage(
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      filePath: pickedImage!.path,
                      fileBytes: kIsWeb ? imageBytes : null,
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gold Collection Admin")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => showAddOrEditDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add New Collection"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: controller.collections.isEmpty
                  ? const Center(child: Text("No collections available"))
                  : ListView.builder(
                      itemCount: controller.collections.length,
                      itemBuilder: (context, index) {
                        final item = controller.collections[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item.title),
                            subtitle: Text(item.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () =>
                                      showAddOrEditDialog(existing: item),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Confirm Delete"),
                                        content: const Text(
                                          "Are you sure you want to delete this collection?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(
                                                context,
                                              ); // Close the dialog
                                              await controller.deleteCollection(
                                                item.id,
                                              ); // Call delete
                                            },
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
