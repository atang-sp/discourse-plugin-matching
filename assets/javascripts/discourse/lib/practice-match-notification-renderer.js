import { i18n } from "discourse-i18n";

const PRACTICE_MATCH_MESSAGE =
  "practice_matching.notification.mutual_match";

export default function practiceMatchNotificationRenderer(
  NotificationTypeBase
) {
  return class extends NotificationTypeBase {
    get linkHref() {
      if (
        this.notification.data.message === PRACTICE_MATCH_MESSAGE &&
        this.notification.data.action_url
      ) {
        return this.notification.data.action_url;
      }

      return super.linkHref;
    }

    get linkTitle() {
      if (this.notification.data.title) {
        return i18n(this.notification.data.title);
      }
    }

    get icon() {
      return `notification.${this.notification.data.message}`;
    }
  };
}
