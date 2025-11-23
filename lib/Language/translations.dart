// ignore_for_file: equal_keys_in_map

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // 🌐 English
    'en_US': {
      // General / HomePage
      'app_name': 'Suba Gold Purchase App',
      'marquee_text':
          '🏢 Sri Subalakshmi Jewellery –   📞  94872 21747 | 90436 53108   🌐 www.subagold.com    🏠 158-1, Near Subramania Kovil & 167-1, Kadaiveethi, Pollachi',
      'welcome_text': 'Welcome to Suba Gold DigiGold!',
      'explore_collections':
          'Explore our premium gold collections and festival offers.',
      'home': 'Home',
      'my_plans': 'My Plans',
      'collections': 'Collections',
      'history': 'History',
      'profile': 'Profile',

      // Gold & Silver Cards
      'gold_card_title': 'Gold Price',
      'gold_card_price': '₹50000 / 10g',
      'gold_card_change': '+₹200 Today',
      'silver_card_title': 'Silver Price',
      'silver_card_price': '₹650 / 1g',
      'silver_card_change': '+₹5 Today',

      // Scheme Section
      'scheme_section_title': 'Our Schemes',
      'my_schemes': 'My Schemes',
      'active_schemes': 'Active Schemes',
      'completed_schemes': 'Completed Schemes',
      'no_schemes': 'No active schemes found!',
      'join_new_scheme': 'Join a New Scheme',

      // My Plans / Schemes Page
      'scheme_details': 'Scheme Details',
      'scheme_type': 'Scheme Type',
      'metal': 'Metal',
      'duration': 'Duration',
      'monthly': 'Monthly',
      'one_time': 'One-Time',
      'pay_plan': 'Pay Plan',
      'no_scheme_found': 'No schemes found',
      'flexible_plan': 'Flexible Plan',
      'fixed_plan': 'Fixed Monthly Plan',

      // Profile / KYC
      'my_profile': 'My Profile',
      'my_account': 'My Account',
      'kyc_update': 'KYC Update',
      'logout': 'Logout',
      'referral_code': 'Referral Code',
      'language': 'Language',
      'tamil': 'Tamil',
      'english': 'English',
      "are_you_sure_logout": "Are you sure you want to logout?",
      "cancel": "Cancel",
      "yes": "Yes",

      // KYC Page
      'kyc_verification': 'KYC Verification',
      'fill_details': 'Please fill in your details',
      'full_name': 'Full Name',
      'enter_name': 'Enter your name',
      'pan_number': 'PAN Card Number',
      'enter_pan': 'Enter PAN number',
      'valid_pan': 'Enter valid PAN number',
      'aadhaar_number': 'Aadhaar Number',
      'enter_aadhaar': 'Enter Aadhaar number',
      'aadhaar_length': 'Aadhaar must be 12 digits',
      'submit_kyc': 'Submit KYC',
      'submitted': 'Submitted',
      'kyc_success': 'Your KYC is submitted successfully!',
      'ok': 'OK',

      // Referral Page
      'referral_copied': 'Referral code copied!',
      'share_referral': 'Join using my referral code:',
      'enter_referral': 'Enter Referral Code',
      'referral_hint': 'e.g. SUBAGOLD123',
      'submit': 'Submit',
      'token_not_found': 'User token not found.',
      'referral_applied': 'Referral code applied successfully!',
      'referral_failed': 'Failed to apply referral code.',
      'no_user_data': 'No user data',
      'refer_earn': 'Refer & Earn',
      'invite_rewards': 'Invite & Earn Rewards!',
      'invite_description':
          'Refer your friends and earn exciting rewards when they sign up using your code.',
      'share_code': 'Share Referral Code',
      'terms_conditions': 'Terms & Conditions',
      'referral_terms':
          '• You and your friend both get ₹10 credit when they sign up using your referral code.\n• Referral rewards will be credited after your friend makes their first transaction.\n• You can invite unlimited friends and stack rewards.\n• Fake or duplicate referrals may result in disqualification.',
      'have_referral': 'Have a referral code?',

      // Edit Profile
      'edit_profile': 'Edit Profile',
      'create_profile': 'Create Profile',
      'name': 'Name',
      'address': 'Address',
      'ifsc': 'IFSC',
      'account_no': 'Account No',
      'pick_aadhar_image': 'Pick Aadhar Image',
      'current_aadhar': 'Current Aadhar Image',
      'selected_new_image': 'Selected New Image',
      'save_changes': 'Save Changes',
      'required': 'is required',
      'ifsc_required': 'IFSC code is required',
      'ifsc_invalid': 'IFSC must be 4 letters followed by 7 digits',
      'aadhar_required': 'Aadhar Number is required',
      'aadhar_invalid': 'Aadhaar must be exactly 12 digits',
      'account_required': 'Account Number is required',
      'account_invalid': 'Account number must be 9 to 18 digits',

      // ProfilePage
      'credits': 'Credits',
      'aadhar_image': 'Aadhar Image',
      'copy': 'Copy',
      'copied': 'Copied!',

      // BuyGoldPage
      'buy_gold': 'Buy Gold',
      'no_flexi_plan': 'No Flexi Plan found',
      'error': 'Error',
      'explore_investment_schemes': 'Explore Our Investment Schemes',

      // MainCollectionsPage
      'our_jewellery_collections': 'Our Jewellery Collections',
      'gold': 'Gold',
      'silver': 'Silver',

      // OrderHistoryPage
      'order_history': 'Order History',
      'no_fixed_history': 'No Fixed Plan history found.',
      'no_flexible_history': 'No Flexible Plan history found.',

      // App Transaction
      'buy_text': 'BUY',
      'grams': 'Grams',
      'metal': 'Metal',
      'payment_month': 'Payment Month',
      'date': 'Date',
      'amount_paid': 'Amount Paid',
      'transaction_id': 'Transaction ID',
      'flexible_plan_trans': 'Flexible Plan',
      'daily_plan_trans': 'Daily Saving Plan',
      'fixed_plan_trans': 'Fixed Monthly Plan',
      'weekly_plan_trans': 'Weekly Saver Plan',

      // Gold Card
      'gold_24k': 'Gold 24K',
      'rate_not_available': 'Rate not available',
      'per_gram': '/ gram',
      // Silver Card
      'silver_999': 'Pure Silver',
      'rate_not_available': 'Rate not available',
      'per_gram': '/ gram',

      // DIgi Gold APP Overview
      'app_overview_title': 'Suba Gold DigiGold App',
      'app_overview_subtitle':
          'Your Trusted Partner in Digital Gold Saving & Shopping',
      'app_overview_description':
          'With Suba Gold DigiGold App, you can effortlessly invest in digital gold, '
          'track your savings, and shop for premium gold jewelry from our official store.\n\n'
          '✓ Flexible Saving Schemes\n'
          '✓ Secure Transactions\n'
          '✓ Doorstep Delivery of Gold\n\n'
          'Experience transparency, trust, and tradition—all in one place.',
      // Schemes Page
      'flexible_gold_plan': 'Flexible Gold Plan',
      'fixed_gold_plan': 'Fixed Gold Plan',
      'flexible_gold_plan_desc':
          'Invest any amount, anytime. Enjoy full flexibility & liquidity with no lock-in period.',
      'fixed_gold_plan_desc':
          'Invest a fixed amount monthly and receive assured returns over a defined duration.',
      'create_scheme': 'Create Scheme',
      'join_now': 'Join Now',
      'already_joined': 'Already Joined',
      //Gold Collections Page
      'welcome_gold_collection': 'Welcome to the Gold Collection!',
      'explore_more_categories': 'Explore more categories soon...',
      //Silver Collections Page
      'welcome_silver_collection': 'Welcome to the Silver Collection!',
      'explore_more_categories': 'Explore more categories soon...',
      //Terms & Conditions
      'refer_earn': 'Refer & Earn',
      'invite_rewards': 'Invite Rewards',
      'invite_description':
          'Share your referral code and earn rewards when your friends join.',
      'referral_copied': 'Referral code copied to clipboard!',
      'share_referral': 'Share your referral code:',
      'referral_applied': 'Referral code applied successfully!',
      'referral_failed': 'Failed to apply referral code.',
      'error_occurred': 'An error occurred',
      'token_not_found': 'Authentication token not found.',
      'enter_referral': 'Enter Referral Code',
      'referral_hint': 'Enter your friend\'s referral code',
      'submit': 'Submit',
      'have_referral': 'Have a referral code?',
      'share_code': 'Share Code',
      'terms_conditions': 'Terms & Conditions',
      'already_joined': 'Already Joined',
      'join_now': 'Join Now',
      'no_user_data': 'No user data found.',
      //FontSize
      'font_settings_title': 'Font Settings',
      'adjust_text_size': 'Adjust Text Size',
      'preview_title': 'Preview',
      'preview_description': 'This is how your text will look in the app.',
      'font_size_label': 'Font Size',
      'smaller_button': 'Smaller',
      'larger_button': 'Larger',
      'reset_button': 'Reset',
      'save_apply_button': 'Save & Apply',
      'font_updated_title': 'Font Updated',
      'font_updated_message':
          'Your preferred font size has been applied successfully.',
      //Contact Us Page
      'contact_us': 'Contact Us',
      'call_us': 'Call Us',
      'whatsapp': 'WhatsApp',
      'instagram': 'Instagram',
      'find_us': 'Find Us on Map',
      //Terms & Conditions
      
          'gold_purchase_only': 'Scheme applicable for gold purchase only',
          'scheme_duration': 'Scheme duration is 11 months',
          'fixed_monthly_amount': 'Fixed monthly amount to be paid',
          'bonus_if_all_paid': 'Bonus applicable if all months are paid',
          'missed_month': 'If any month is missed, bonus will not be given',
          'no_bonus_conditions': 'No bonus for incomplete payments',
          'redemption_after_11_months': 'Redemption only after 11 months',
          'redemption_gold_only': 'Redemption in gold only',
          'gold_rate_on_redemption': 'Gold rate applicable at redemption time',
          'making_charges_extra': 'Making charges extra as applicable',
          'bonus_special_case': 'Bonus applicable only in special cases',
          'min_1gram_only': 'Minimum redemption — 1 gram only',
          'balance_if_less': 'Balance less than 1 gram will be adjusted',
          'premature_closure': 'Premature closure not allowed',
          'no_cash_refund': 'No cash refund permitted',
          'non_transferable': 'Scheme not transferable',
          'valid_id_required': 'Valid ID proof required',
          'save_receipts': 'Please save all receipts safely',
          'disputes_pollachi': 'All disputes subject to Pollachi jurisdiction',
          'management_final_decision': 'Management’s decision is final',
    },

    // 🌕 Tamil
    'ta_IN': {
      // General / HomePage
      'app_name': 'சுபா தங்கக் கொள்முதல் செயலி',
      'marquee_text':
          '🏢  ஸ்ரீ சுபலக்ஷ்மி ஜூவல்லரி   📞  94872 21747 | 90436 53108    🌐 www.subagold.com   🏠 158-1, சுப்ரமணிய கோவில் அருகே & 167-1, கடைவீதி, பொள்ளாச்சி',
      'welcome_text': 'சுபா கோல்ட் டிஜிகோல்டுக்கு வரவேற்கிறோம்!',
      'explore_collections':
          'எங்கள் பிரீமியம் தங்கக் தொகுப்புகள் மற்றும் விழா சலுகைகளை கண்டறியவும்.',
      'home': 'முகப்பு',
      'my_plans': 'எனது திட்டங்கள்',
      'collections': 'தொகுப்புகள்',
      'history': 'வரலாறு',
      'profile': 'சுயவிவரம்',

      // Gold & Silver Cards
      'gold_card_title': 'தங்கம் விலை',
      'gold_card_price': '₹50000 / 10கிராம்',
      'gold_card_change': '+₹200 இன்று',
      'silver_card_title': 'வெள்ளி விலை',
      'silver_card_price': '₹650 / 1கிராம்',
      'silver_card_change': '+₹5 இன்று',

      // Scheme Section
      'scheme_section_title': 'எங்கள் திட்டங்கள்',
      'my_schemes': 'என் திட்டங்கள்',
      'active_schemes': 'செயலில் உள்ள திட்டங்கள்',
      'completed_schemes': 'முடிந்த திட்டங்கள்',
      'no_schemes': 'செயலில் எந்தத் திட்டமும் இல்லை!',
      'join_new_scheme': 'புதிய திட்டத்தில் சேரவும்',

      // My Plans / Schemes Page
      'scheme_details': 'திட்ட விவரங்கள்',
      'scheme_type': 'திட்ட வகை',
      'metal': 'உலோகம்',
      'duration': 'காலம்',
      'monthly': 'மாதாந்திர',
      'one_time': 'ஒருமுறை',
      'pay_plan': 'கட்டணம் செலுத்து',
      'no_scheme_found': 'திட்டங்கள் எதுவும் இல்லை',
      'flexible_plan': 'நெகிழ்வான திட்டம்',
      'fixed_plan': 'நிலையான மாதாந்திர திட்டம்',

      // Profile / KYC
      'my_profile': 'என் சுயவிவரம்',
      'my_account': 'என் கணக்கு',
      'kyc_update': 'KYC புதுப்பிக்க',
      'logout': 'வெளியேறு',
      'referral_code': 'பரிந்துரை குறியீடு',
      'language': 'மொழி',
      'tamil': 'தமிழ்',
      'english': 'ஆங்கிலம்',
      "are_you_sure_logout": "நீங்கள் வெளியேற விரும்புகிறீர்களா?",
      "cancel": "ரத்து செய்",
      "yes": "ஆம்",

      // KYC Page
      'kyc_verification': 'KYC சரிபார்ப்பு',
      'fill_details': 'தயவுசெய்து உங்கள் விவரங்களை உள்ளிடவும்',
      'full_name': 'முழு பெயர்',
      'enter_name': 'உங்கள் பெயரை உள்ளிடவும்',
      'pan_number': 'பான் கார்டு எண்',
      'enter_pan': 'பான் எண் உள்ளிடவும்',
      'valid_pan': 'செல்லுபடியாகும் பான் எண் உள்ளிடவும்',
      'aadhaar_number': 'ஆதார் எண்',
      'enter_aadhaar': 'ஆதார் எண் உள்ளிடவும்',
      'aadhaar_length': 'ஆதார் 12 இலக்கங்கள் இருக்க வேண்டும்',
      'submit_kyc': 'KYC சமர்ப்பிக்கவும்',
      'submitted': 'சமர்ப்பிக்கப்பட்டது',
      'kyc_success': 'உங்கள் KYC வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!',
      'ok': 'சரி',

      // Referral Page
      'referral_copied': 'பரிந்துரை குறியீடு நகலெடுக்கப்பட்டது!',
      'share_referral': 'என் பரிந்துரை குறியீட்டை பயன்படுத்தி இணையுங்கள்:',
      'enter_referral': 'பரிந்துரை குறியீட்டை உள்ளிடவும்',
      'referral_hint': 'எ.கா. SUBAGOLD123',
      'submit': 'சமர்ப்பிக்கவும்',
      'token_not_found': 'பயனர் டோக்கன் இல்லை.',
      'referral_applied': 'பரிந்துரை குறியீடு வெற்றிகரமாக பயன்படுத்தப்பட்டது!',
      'referral_failed': 'பரிந்துரை குறியீடு செயல்படுத்த முடியவில்லை.',
      'no_user_data': 'பயனர் தரவு இல்லை',
      'refer_earn': 'பரிந்துரை செய்து சம்பாதிக்கவும்',
      'invite_rewards': 'நண்பர்களை அழைத்து பரிசுகளை சம்பாதிக்கவும்!',
      'invite_description':
          'உங்கள் நண்பர்களை பரிந்துரைத்து, அவர்கள் உங்கள் குறியீட்டை பயன்படுத்தி பதிவு செய்தால் பரிசுகள் சம்பாதிக்கவும்.',
      'share_code': 'பரிந்துரை குறியீட்டை பகிரவும்',
      'terms_conditions': 'விதிமுறைகள் & நிபந்தனைகள்',
      'referral_terms':
          '• உங்கள் நண்பரும் உங்கள் பரிந்துரை குறியீட்டை பயன்படுத்தி பதிவு செய்தால் இருவருக்கும் ₹10 கிரெடிட் வழங்கப்படும்.\n• உங்கள் நண்பர் முதல் பரிவர்த்தனையை செய்த பிறகு பரிந்துரை பரிசுகள் வழங்கப்படும்.\n• நீங்கள் எல்லா நண்பர்களையும் அழைக்கலாம் மற்றும் பரிசுகளை சேர்க்கலாம்.\n• போலி அல்லது நகலான பரிந்துரைகள் தகுதி நீக்கம் செய்யப்படும்.',
      'have_referral': 'பரிந்துரை குறியீடு உள்ளதா?',

      // Edit Profile
      'edit_profile': 'சுயவிவரத்தைத் திருத்து',
      'create_profile': 'சுயவிவரம் உருவாக்கு',
      'name': 'பெயர்',
      'address': 'முகவரி',
      'ifsc': 'IFSC',
      'account_no': 'கணக்கு எண்',
      'pick_aadhar_image': 'ஆதார் படத்தைத் தேர்வு செய்',
      'current_aadhar': 'தற்போதைய ஆதார் படம்',
      'selected_new_image': 'தேர்ந்தெடுக்கப்பட்ட புதிய படம்',
      'save_changes': 'மாற்றங்களைச் சேமி',
      'required': 'தேவை',
      'ifsc_required': 'IFSC குறியீடு தேவை',
      'ifsc_invalid': 'IFSC 4 எழுத்துகள் மற்றும் 7 எண்கள் இருக்க வேண்டும்',
      'aadhar_required': 'ஆதார் எண் தேவை',
      'aadhar_invalid': 'ஆதார் 12 இலக்கங்கள் இருக்க வேண்டும்',
      'account_required': 'கணக்கு எண் தேவை',
      'account_invalid': 'கணக்கு எண் 9 முதல் 18 இலக்கங்கள் இருக்க வேண்டும்',

      // ProfilePage
      'credits': 'கிரெடிட்ஸ்',
      'aadhar_image': 'ஆதார் படம்',
      'copy': 'நகல் எடு',
      'copied': 'நகலெடுக்கப்பட்டது!',

      // BuyGoldPage
      'buy_gold': 'தங்கம் வாங்கவும்',
      'no_flexi_plan': 'எந்த Flexi திட்டமும் இல்லை',
      'error': 'பிழை',
      'explore_investment_schemes': 'எங்கள் முதலீட்டு திட்டங்களை ஆராய்க',

      // MainCollectionsPage
      'our_jewellery_collections': 'எங்கள் ஆபரணத் தொகுப்புகள்',
      'gold': 'தங்கம்',
      'silver': 'வெள்ளி',

      // OrderHistoryPage
      'order_history': 'ஆர்டர் வரலாறு',
      'no_fixed_history': 'நிலையான திட்ட வரலாறு எதுவும் இல்லை.',
      'no_flexible_history': 'நெகிழ்வான திட்ட வரலாறு எதுவும் இல்லை.',
      // App Transaction
      'buy_text': 'வாங்கவும்',
      'grams': 'கிராம்',
      'metal': 'உலோகம்',
      'payment_month': 'கட்டணம் செய்யப்பட்ட மாதம்',
      'date': 'தேதி',
      'amount_paid': 'செலுத்திய தொகை',
      'transaction_id': 'பரிவர்த்தனை ஐடி',
      'flexible_plan_trans': 'நெகிழ்வான திட்டம்',
      'daily_plan_trans': 'தினசரி சேமிப்பு திட்டம்',
      'fixed_plan_trans': 'நிலையான மாதாந்திர திட்டம்',
      'weekly_plan_trans': 'வாராந்திர சேமிப்பு திட்டம்',

      // Gold Card
      'gold_24k': 'தங்கம் 24K',
      'rate_not_available': 'விலை கிடைக்கவில்லை',
      'per_gram': '/ கிராம்',

      // Silver Card
      'silver_999': 'புரி வெள்ளி',
      'rate_not_available': 'விலை கிடைக்கவில்லை',
      'per_gram': '/ கிராம்',

      // DIgi Gold APP Overview
      'app_overview_title': 'சுபா கோல்ட் டிஜிகோல்ட் செயலி',
      'app_overview_subtitle':
          'டிஜிட்டல் தங்க சேமிப்பு & வாங்குதலில் உங்கள் நம்பகமான நண்பர்',
      'app_overview_description':
          'சுபா கோல்ட் டிஜிகோல்ட் செயலியுடன், நீங்கள் எளிதாக டிஜிட்டல் தங்கத்தில் முதலீடு செய்யலாம், '
          'உங்கள் சேமிப்புகளை கண்காணிக்கலாம், மற்றும் எங்கள் அதிகாரப்பூர்வக் கடையிலிருந்து பிரீமியம் தங்க ஆபரணங்களை வாங்கலாம்.\n\n'
          '✓ நெகிழ்வான சேமிப்பு திட்டங்கள்\n'
          '✓ பாதுகாப்பான பரிவர்த்தனைகள்\n'
          '✓ வீட்டிற்கே தங்கம் டெலிவரி\n\n'
          'பாரம்பரியம், நம்பிக்கை மற்றும் தெளிவை ஒரே இடத்தில் அனுபவிக்கவும்.',
      // Schemes Page
      'flexible_gold_plan': 'நெகிழ்வான தங்கத் திட்டம்',
      'fixed_gold_plan': 'நிலையான தங்கத் திட்டம்',
      'flexible_gold_plan_desc':
          'ஏதேனும் தொகையை எப்போது வேண்டுமானாலும் முதலீடு செய்யலாம். கட்டுப்பாடு இல்லாமல் முழுமையான நெகிழ்வும் திரும்பப்பெறலும் அனுபவிக்கவும்.',
      'fixed_gold_plan_desc':
          'நிலையான தொகையை மாதந்தோறும் முதலீடு செய்து, வரையறுக்கப்பட்ட காலத்திற்கு உறுதி செய்யப்பட்ட வருமானங்களை பெறவும்.',
      'create_scheme': 'திட்டம் உருவாக்கு',
      'join_now': 'இப்போது சேரவும்',
      'already_joined': 'ஏற்கனவே சேர்ந்தது',
      //Gold Collections Page
      'welcome_gold_collection': 'தங்கத் தொகுப்புக்கு வரவேற்கிறோம்!',
      'explore_more_categories': 'மேலும் பிரிவுகளை விரைவில் ஆராயுங்கள்...',
      //Silver Collections Page
      'welcome_silver_collection': 'வெள்ளி தொகுப்புக்கு வரவேற்கிறோம்!',
      'explore_more_categories': 'மேலும் பிரிவுகளை விரைவில் ஆராயுங்கள்...',
      //Terms & Conditions
      'refer_earn': 'பிரிந்து சம்பாதிக்கவும்',
      'invite_rewards': 'அழைப்புக் க்கு பரிசுகள்',
      'invite_description':
          'உங்கள் நண்பர்களை அழைத்து உங்கள் ரெஃபரல் குறியீட்டை பகிர்ந்து பரிசுகளை சம்பாதியுங்கள்.',
      'referral_copied': 'ரெஃபரல் குறியீடு கிளிப்போர்டில் நகலெடுக்கப்பட்டது!',
      'share_referral': 'உங்கள் ரெஃபரல் குறியீட்டை பகிரவும்:',
      'referral_applied': 'ரெஃபரல் குறியீடு வெற்றிகரமாக பயன்படுத்தப்பட்டது!',
      'referral_failed': 'ரெஃபரல் குறியீட்டை பயன்படுத்த முடியவில்லை.',
      'error_occurred': 'ஒரு பிழை நிகழ்ந்தது',
      'token_not_found': 'அங்கீகார டோக்கன் காணப்படவில்லை.',
      'enter_referral': 'ரெஃபரல் குறியீட்டை உள்ளிடவும்',
      'referral_hint': 'உங்கள் நண்பரின் ரெஃபரல் குறியீட்டை உள்ளிடவும்',
      'submit': 'சமர்ப்பிக்கவும்',
      'have_referral': 'ரெஃபரல் குறியீடு உள்ளதா?',
      'share_code': 'குறியீட்டை பகிரவும்',
      'terms_conditions': 'விதிமுறைகள் மற்றும் நிபந்தனைகள்',
      'already_joined': 'ஏற்கனவே சேர்ந்துள்ளீர்',
      'join_now': 'இப்போது சேர்ந்துகொள்ளவும்',
      'no_user_data': 'பயனர் தரவு காணப்படவில்லை.',
      //FontSize
      'font_settings_title': 'எழுத்துரு அமைப்புகள்',
      'adjust_text_size': 'எழுத்துரு அளவை மாற்றவும்',
      'preview_title': 'முன்னோட்டம்',
      'preview_description': 'பயன்பாட்டில் உங்கள் எழுத்து இவ்வாறு காணப்படும்.',
      'font_size_label': 'எழுத்துரு அளவு',
      'smaller_button': 'சிறியது',
      'larger_button': 'பெரியது',
      'reset_button': 'மீட்டமை',
      'save_apply_button': 'சேமித்து பயன்படுத்தவும்',
      'font_updated_title': 'எழுத்துரு புதுப்பிக்கப்பட்டது',
      'font_updated_message':
          'உங்கள் எழுத்துரு அளவு வெற்றிகரமாக மாற்றப்பட்டது.',

      //Contact Us Page
      'contact_us': 'தொடர்பு கொள்ள',
      'call_us': 'அழைக்கவும்',
      'whatsapp': 'வாட்ஸ்அப்',
      'instagram': 'இன்ஸ்டாகிராம்',
      'find_us': 'மேப்பில் காணவும்',
      //Terms & Conditions
          'gold_purchase_only': 'திட்டம் தங்கக் கொள்முதலுக்கே பொருந்தும்',
          'scheme_duration': 'திட்ட காலம் 11 மாதங்கள்',
          'fixed_monthly_amount': 'நிலையான மாதாந்திர தொகை செலுத்தப்பட வேண்டும்',
          'bonus_if_all_paid': 'எல்லா மாதங்களும் செலுத்தப்பட்டால் மட்டுமே போனஸ் வழங்கப்படும்',
          'missed_month': 'ஏதேனும் மாதம் தவறவிட்டால், போனஸ் வழங்கப்படாது',
          'no_bonus_conditions': 'முழுமையான கட்டணங்களுக்கு போனஸ் இல்லை',
          'redemption_after_11_months': '11 மாதங்களுக்கு பிறகு மட்டுமே மீட்பு செய்யலாம்',
          'redemption_gold_only': 'தங்கத்தில் மட்டுமே மீட்பு செய்யலாம்',
          'gold_rate_on_redemption': 'மீட்பின் போது தங்க விலை பொருந்தும்',
          'making_charges_extra': 'உருவாக்கும் கட்டணங்கள் கூடுதல் ஆகும்',
          'bonus_special_case': 'போனஸ் சிறப்பு சூழ்நிலைகளில் மட்டுமே வழங்கப்படும்',
          'min_1gram_only': 'குறைந்தபட்ச மீட்பு — 1 கிராம் மட்டுமே',
          'balance_if_less': '1 கிராமுக்கு குறைவான இருப்பு சரிசெய்யப்படும்',
          'premature_closure': 'முன்கூட்டிய மூடல் அனுமதிக்கப்படாது',
          'no_cash_refund': 'பணத் திருப்பி வழங்கல் அனுமதிக்கப்படாது',
          'non_transferable': 'திட்டம் மாற்ற முடியாதது',
          'valid_id_required': 'செல்லுபடியாகும் அடையாள சான்று தேவை',
          'save_receipts': 'எல்லா ரசீத்களையும் பாதுகாப்பாக சேமிக்கவும்',
          'disputes_pollachi': 'எல்லா முரண்பாடுகளும் பொள்ளாச்சி நீதிமன்றத்தின் அதிகாரத்திற்கு உட்பட்டவை',
          'management_final_decision': 'மேலாண்மையின் முடிவு இறுதி ஆகும்',
    },
  };
}
