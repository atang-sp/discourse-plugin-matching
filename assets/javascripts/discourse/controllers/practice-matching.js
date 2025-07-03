import Controller from "@ember/controller";
import { inject as service } from "@ember/service";

export default Controller.extend({
  router: service(),
  
  practiceInterests: [],
  practiceTargets: [],
  practiceMatches: [],

  actions: {
    addInterest() {
      // TODO: Implement user selection modal
      console.log("Add interest action triggered");
    },

    removeInterest(username) {
      // This will be handled by the route
      this.send("removeInterest", username);
    },

    viewUserProfile(username) {
      this.router.transitionTo("user", username);
    }
  }
}); 