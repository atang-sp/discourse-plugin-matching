import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";
import practiceMatchNotificationRenderer from "discourse/plugins/discourse-plugin-matching/discourse/lib/practice-match-notification-renderer";

export default {
  name: "practice-matching",

  initialize() {
    withPluginApi((api) => {
      api.registerNotificationTypeRenderer(
        "custom",
        practiceMatchNotificationRenderer
      );

      // 添加导航栏项目（Discourse 3.5 推荐方式）
      api.addNavigationBarItem({
        name: "practice-matching",
        displayName: i18n("practice_matching.nav_title"),
        href: "/practice-matching",
        icon: "handshake",
      });
    });
  },
};
