import { withPluginApi } from "discourse/lib/plugin-api";

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
    });
  }
}; 