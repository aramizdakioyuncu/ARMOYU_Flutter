import 'package:ARMOYU/app/translations/en.dart';
import 'package:ARMOYU/app/translations/tr.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationKeys = {
    'en': en,
    'tr': tr,
  };
}

class TranslateKeys {
  static const currentLanguage = 'current_language';
}

class CommonKeys {
  static const search = 'search';
  static const empty = 'empty';
  static const join = 'join';
  static const leave = 'leave';
  static const cancel = 'cancel';
  static const submit = 'submit';
  static const create = 'create';
  static const share = 'share';
}

//Social
class SocialKeys {
  static const socialStory = 'social_story';
  static const socialLiked = 'social_liked';

  static const socialAddFavorite = 'social_add_favorite';
  static const socialReport = 'social_report';
  static const socialBlock = 'social_block';
  static const socialedit = 'social_edit';
  static const socialdelete = 'social_delete';

  static const socialShare = 'social_share';
  static const socialwritesomething = 'social_write_something';
}

class NotificationKeys {
  static const friendRequests = 'friend_requests';
  static const reviewFriendRequests = 'review_friend_requests';
  static const groupRequests = 'group_requests';
  static const reviewGroupRequests = 'review_group_requests';
}

class ProfileKeys {
  static const profilerefresh = 'profile_refresh';
  static const profileEdit = 'profile_edit';
  static const profilecopylink = 'profile_copy_link';
  static const profileblock = 'profile_block';
  static const profilereport = 'profile_report';
  static const profileremovefriend = 'profile_eemove_friend';
  static const profilepoke = 'profile_poke';

  static const profilePost = 'profile_post';
  static const profilefriend = 'profile_friend';
  static const profileaward = 'profile_award';

  static const profilePosts = 'profile_posts';
  static const profileMedia = 'profile_media';
  static const profileMentions = 'profile_mentions';
}

class ChatKeys {
  static const chat = 'chat';
  static const chatyournote = 'chat_your_note';
  static const chatnewchat = 'chat_new_chat';
}

class GroupKeys {
  static const createGroup = 'create_group';
  static const groupName = 'group_name';
  static const groupShortname = 'group_short_name';
}

class SchoolKeys {
  static const joinSchool = 'join_school';
  static const schoolPassword = 'school_password';
  static const schoolJoin = 'school_join';
}

class FoodKeys {
  static const orderExplain = 'order_explain';
  static const foodProduct = 'food_product';
  static const foodPrice = 'food_price';
}

class PollKeys {
  static const createPoll = 'create_poll';
  static const pollquestion = 'poll_question';
  static const pollanswers = 'poll_answers';
  static const pollOption = 'poll_option';
  static const pollAddOption = 'poll_add_option';

  static const selectHour = 'select_hour';
  static const selectDate = 'select_date';
  static const selectPollMultipleChoice = 'select_poll_multiple_chocie';
  static const selectPollCheckboxes = 'select_poll_check_boxes';
  static const selectPollShortAnswer = 'select_poll_short_answer';

  static const pollExpired = 'poll_expired';
  static const pollVoted = 'poll_voted';
  static const pollnotVoted = 'poll_not_voted';
}

class InviteKeys {
  static const normalAccount = 'normal_account';
  static const verifiedAccount = 'verified_account';
  static const sendVerificationCode = 'send_verification_code';
}

class JoinUsKeys {
  static const phoneNumberRegistered = 'phone_number_registered';
  static const profilePhoto = 'profile_photo';
  static const noPenalty = 'no_penalty';
  static const noProvocation = 'no_provocation';

  static const selectAnItem = 'select_an_item';
  static const selectAPosition = 'select_a_position';
  static const whyJoinTheTeam = 'why_join_the_team';
  static const whyChooseThisPermission = 'why_choose_this_permission';
  static const howManyDaysPerWeek = 'how_many_days_per_week';
}

class EventKeys {
  static const eventRules = 'event_rules';
  static const eventcoordinator = 'event_coordinator';
  static const eventdescriptions = 'event_description';
  static const eventParticipationEndedExplain =
      'event_participation_ended_explain';
  static const alreadyJoinedEventWithDeadline =
      'already_joined_event_with_deadline';

  static const readAndAgreeRules = 'read_and_agree_rules';
}

class SettingsKeys {
  //Settings
  static const translation = 'translation';
  static const settings = 'settings';
  static const lastFailedLogin = 'last_failed_login';

  static const applicationAndMedia = 'application_and_media';
  static const devicePermissions = 'device_permissions';
  static const downloadAndArchive = 'download_and_archive';
  static const dataSaver = 'data_saver';
  static const languages = 'languages';
  static const notifications = 'notifications';
  static const blockedList = 'blocked_list';
  static const moreInformationAndSupport = 'more_information_and_support';
  static const help = 'help';
  static const accountStatus = 'account_status';
  static const about = 'about';
  static const addAccount = 'add_account';
  static const logOut = 'log_out';
  static const version = 'version';
}

class DrawerKeys {
  static const drawerMeeting = 'drawer_meeting';
  static const drawerNews = 'drawer_news';
  static const drawerMyGroups = 'drawer_my_groups';
  static const drawerMyGroupscreate = 'drawer_my_groups_create';
  static const drawerMySchools = 'drawer_my_schools';
  static const drawerMySchoolsjoin = 'drawer_my_schools_join';

  static const drawerFood = 'drawer_food';
  static const drawerGames = 'drawer_games';
  static const drawerEvents = 'drawer_events';
  static const drawerPolls = 'drawer_polls';
  static const drawerInvite = 'drawer_invite';
  static const drawerJoinUs = 'drawer_join_us';
  static const drawerSettings = 'drawer_settings';
}

class LoginKeys {
  static const loginKeysUsernameoremail = 'loginkeys_username_or_email';
  static const loginKeysPassword = 'loginkeys_password';
  static const loginKeysLogin = 'loginkeys_login';
  static const loginKeysForgotmypassword = 'loginkeys_forgot_my_password';
  static const loginKeysSignup = 'loginkeys_sign_up';
  static const loginKeysHaveyougotaccount = 'loginkeys_have_you_got_account';
  static const loginKeysPrivacyPolicy = 'loginkeys_privacy_policy';
  static const loginKeysTermsAndConditions = 'loginkeys_terms_and_conditions';
  static const loginKeysacceptanceMessage = 'acceptance_message';
}

class RegisterKeys {
  static const registerKeysfirstname = 'registerkeys_first_name';
  static const registerKeyslastname = 'registerkeys_last_name';
  static const registerKeysusername = 'registerkeys_username';
  static const registerKeysemail = 'registerkeys_email';
  static const registerKeyspassword = 'registerkeys_password';
  static const registerKeysrepeatpassword = 'registerkeys_repeat_password';
  static const registerKeysinvitecode = 'registerkeys_repeat_invitecode';
  static const registerKeyssignup = 'registerkeys_repeat_signup';
  static const registerKeyssignin = 'registerkeys_repeat_signin';
  static const registerKeysifyouhaveaccount =
      'registerkeys_if_you_have_account';
}

class ResetPasswordKeys {
  static const resetPasswordKeysusername = 'resetpasswordkeys_username';
  static const resetPasswordKeysemail = 'resetpasswordkeys_email';
  static const resetPasswordKeyscontinue = 'resetpasswordkeys_continue';
  static const resetPasswordKeyssignin = 'resetpasswordkeys_signin';
  static const resetPasswordKeysifyourememberyourpassword =
      'resetpasswordkeys_if_you_remember_your_password';

  static const resetPasswordKeyscode = 'resetpasswordkeys_code';
  static const resetPasswordKeyscreatepassword =
      'resetpasswordkeys_create_password';
  static const resetPasswordKeysrepeatpassword =
      'resetpasswordkeys_repeat_password';
  static const resetPasswordKeysrepeatsendcode =
      'resetpasswordkeys_create_repeat_send_code';
  static const resetPasswordKeyssave = 'resetpasswordkeys_save';
}

class BlockedListKeys {
  static const noBlockedAccounts = 'no_blocked_accounts';
  static const unblock = 'unblock';
}

class DevicePermissionKeys {
  //Device Permissions
  static const deviceCamera = 'device_camera';
  static const deviceContact = 'device_contact';
  static const deviceLocation = 'device_location';
  static const deviceMicrpohone = 'device_microphone';
  static const deviceNotifications = 'device_notifications';
  static const deviceGranted = 'device_granted';
  static const deviceDenied = 'device_denied';
  static const devicePermanentlyDenied = 'device_permanently_denied';
}

class DataSaverKeys {
  //Data Saver
  static const useLessCellularData = 'use_less_cellular_data';
  static const useLessCellularDataExplain = 'use_less_cellular_data_explain';

  static const uploadMediaInTheLowestQuality =
      'upload_media_in_the_lowest_quality';
  static const uploadMediaInTheLowestQualityExplain =
      'upload_media_in_the_lowest_quality_explain';

  static const disableAutoplayVideos = 'disable_autoplay_videos';
  static const disableAutoplayVideosExplain = 'disable_autoplayVideos_explain';
}

class NotificationsKeys {
  //Notifications
  static const commentLikes = 'comment_likes';
  static const commentLikesExplain = 'comment_likes_explain';

  static const postLikes = 'post_likes';
  static const postLikesExplain = 'post_likes_explain';

  static const comment = 'comment';
  static const commentExplain = 'comment_explain';

  static const commentReplies = 'comment_replies';
  static const commentRepliesExplain = 'comment_replies_explain';

  static const event = 'event';
  static const eventExplain = 'event_explain';

  static const birthdays = 'birthdays';
  static const birthdaysExplain = 'birthdays_explain';

  static const messages = 'messages';
  static const messagesExplain = 'messages_explain';

  static const calls = 'calls';
  static const callsExplain = 'calls_explain';

  static const mentions = 'mentions';
  static const mentionsExplain = 'mentions_explain';
}

class HelpKeys {
  static const reportIssue = 'report_issue';
  static const reportIssueExplain = 'report_issue_explain';

  static const supportRequests = 'support_requests';
  static const supportRequestsExplain = 'support_requests_explain';
}

class AccountStatusKeys {
  static const accountStatusabout = 'account_status_about';

  static const removedContent = 'removed_content';
  static const removedContentExplain = 'removed_content_explain';

  static const myRestrictions = 'my_restrictions';
  static const myRestrictionsExplain = 'my_restrictions_explain';
}

class AboutKeys {
  static const aboutYourAccount = 'about_your_account';
  static const privacyPolicy = 'privacy_policy';
  static const termsOfService = 'terms_of_service';
  static const openSourceLibraries = 'open_source_libraries';
}
