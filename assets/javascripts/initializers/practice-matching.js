import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "practice-matching",

  initialize() {
    withPluginApi("0.8.31", api => {
      // 注册前端路由
      api.modifyClass("router:main", {
        buildRoutes() {
          const routes = this._super(...arguments);
          routes.push({
            path: "/practice-matching",
            route: "practice-matching"
          });
          return routes;
        }
      });

      // 添加导航链接到用户菜单
      api.decorateWidget("header-buttons:before", helper => {
        if (api.getCurrentUser()) {
          return helper.h("li.header-dropdown-toggle.practice-matching-link", [
            helper.h("a", { href: "/practice-matching" }, [
              helper.h("i.fa.fa-handshake"),
              " 实践配对"
            ])
          ]);
        }
      });
    });
  }
}; 