import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";

export default DiscourseRoute.extend({
  model() {
    return ajax("/practice-matching");
  },

  setupController(controller, model) {
    controller.setProperties({
      practiceInterests: model.practice_interests || [],
      practiceTargets: model.practice_targets || [],
      practiceMatches: model.practice_matches || []
    });
  },

  actions: {
    addInterest(username) {
      return ajax("/practice-matching/add", {
        type: "POST",
        data: { username }
      }).then(result => {
        if (result.success) {
          this.refresh();
        }
        return result;
      });
    },

    removeInterest(username) {
      return ajax("/practice-matching/remove", {
        type: "DELETE",
        data: { username }
      }).then(result => {
        if (result.success) {
          this.refresh();
        }
        return result;
      });
    }
  }
}); 