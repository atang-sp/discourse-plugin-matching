import Controller from "@ember/controller";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default Controller.extend({
  dialog: service(),
  flash: service(),

  practiceInterests: [],
  practiceTargets: [],
  practiceMatches: [],

  addInterest: action(function() {
    this.dialog.alert({
      title: "添加实践兴趣",
      message: "请输入用户名：",
      type: "input"
    }).then(username => {
      if (username) {
        this.send("addInterest", username).then(result => {
          if (result.success) {
            this.flash.success(result.message);
          } else {
            this.flash.error(result.error);
          }
        });
      }
    });
  }),

  removeInterest: action(function(username) {
    this.dialog.confirm({
      title: "确认移除",
      message: `确定要从实践兴趣列表中移除 ${username} 吗？`,
      type: "warning"
    }).then(() => {
      this.send("removeInterest", username).then(result => {
        if (result.success) {
          this.flash.success(result.message);
        } else {
          this.flash.error(result.error);
        }
      });
    });
  }),

  viewUserProfile: action(function(username) {
    this.transitionToRoute("user", username);
  })
}); 