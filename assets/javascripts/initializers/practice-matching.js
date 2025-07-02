import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "practice-matching",

  initialize() {
    withPluginApi("0.8.31", api => {
      // Discourse 3.x 不再支持 widget API，这里保留初始化壳子
      // 如需入口按钮，请用 theme component 或 plugin outlet 实现
    });
  }
}; 