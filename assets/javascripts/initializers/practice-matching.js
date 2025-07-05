import { withPluginApi } from "discourse/lib/plugin-api";
import { userPath } from "discourse/lib/url";
import { formatUsername } from "discourse/lib/utilities";
import { i18n } from "discourse-i18n";

export default {
  name: "practice-matching",

  initialize() {
    withPluginApi("0.8.31", api => {
      // 添加导航栏项目（Discourse 3.5 推荐方式）
      api.addNavigationBarItem({
        name: "practice-matching",
        displayName: "实践配对",
        href: "/practice-matching",
        icon: "handshake"
      });

      // 注册通知类型渲染器
      if (api.registerNotificationTypeRenderer) {
        api.registerNotificationTypeRenderer("practice_match_found", (NotificationTypeBase) => {
          return class extends NotificationTypeBase {
            get linkHref() {
              return "/practice-matching";
            }

            get linkTitle() {
              return i18n("notifications.titles.practice_match_found");
            }

            get icon() {
              return "handshake";
            }

            get label() {
              return formatUsername(this.notification.data.display_username);
            }

            get description() {
              return i18n("notifications.practice_match_found", {
                username: this.notification.data.display_username
              });
            }
          };
        });
      }
    });
  }
}; 