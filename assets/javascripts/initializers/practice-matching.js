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

      // 添加导航栏项目（Discourse 3.5 推荐方式）
      api.addNavigationBarItem({
        name: "practice-matching",
        displayName: "实践配对",
        href: "/practice-matching",
        icon: "handshake"
      });

      // 添加用户菜单项
      api.decorateWidget("user-menu-links", helper => {
        if (api.getCurrentUser()) {
          return helper.h("li.practice-matching-menu-item", [
            helper.h("a", { href: "/practice-matching" }, [
              helper.h("i.fa.fa-handshake"),
              " 实践配对管理"
            ])
          ]);
        }
      });

      // 添加用户资料页面的实践配对按钮
      api.decorateWidget("user-profile-controls", helper => {
        const user = helper.attrs.user;
        const currentUser = api.getCurrentUser();
        
        if (currentUser && user && currentUser.id !== user.id) {
          return helper.h("li.practice-matching-profile-control", [
            helper.h("a.btn.btn-primary", { href: "/practice-matching" }, [
              helper.h("i.fa.fa-handshake"),
              " 实践配对"
            ])
          ]);
        }
      });

      // 添加用户卡片中的实践配对按钮
      api.decorateWidget("user-card-controls", helper => {
        const user = helper.attrs.user;
        const currentUser = api.getCurrentUser();
        
        if (currentUser && user && currentUser.id !== user.id) {
          return helper.h("li.practice-matching-card-control", [
            helper.h("a.btn.btn-primary", { href: "/practice-matching" }, [
              helper.h("i.fa.fa-handshake"),
              " 实践配对"
            ])
          ]);
        }
      });
    });
  }
}; 