import { withPluginApi } from "discourse/lib/plugin-api";
import { getOwner } from "discourse-common/lib/get-owner";
import { ajax } from "discourse/lib/ajax";

export default {
  name: "practice-matching",

  initialize() {
    withPluginApi("0.8.31", api => {
      // 在用户卡片中添加实践配对按钮
      api.attachWidgetAction("user-card", "practiceMatching", function() {
        const router = getOwner(this).lookup("router:main");
        router.transitionTo("practice-matching");
      });

      // 在用户资料页面添加实践配对按钮
      api.attachWidgetAction("user-profile", "practiceMatching", function() {
        const router = getOwner(this).lookup("router:main");
        router.transitionTo("practice-matching");
      });

      // 添加实践配对按钮到用户卡片
      api.decorateWidget("user-card:actions", helper => {
        const user = helper.attrs.user;
        if (user.can_manage_practice_interests) {
          return helper.h(
            "li.practice-matching-button",
            helper.h(
              "a.btn.btn-primary",
              {
                attributes: {
                  "data-action": "practiceMatching",
                  title: "管理实践配对"
                }
              },
              "实践配对"
            )
          );
        }
      });

      // 添加实践配对按钮到用户资料页面
      api.decorateWidget("user-profile:buttons", helper => {
        const user = helper.attrs.user;
        if (user.can_manage_practice_interests) {
          return helper.h(
            "button.btn.btn-primary.practice-matching-btn",
            {
              attributes: {
                "data-action": "practiceMatching",
                title: "管理实践配对"
              }
            },
            "实践配对"
          );
        }
      });

      // 添加实践配对路由
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

      // 添加实践配对页面组件
      api.modifyClass("controller:application", {
        actions: {
          "practice-matching"() {
            this.transitionToRoute("practice-matching");
          }
        }
      });
    });
  }
}; 