import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";

export default {
  name: "practice-matching",

  initialize() {
    withPluginApi(api => {
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
