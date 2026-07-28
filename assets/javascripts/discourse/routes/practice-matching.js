import { ajax } from "discourse/lib/ajax";
import DiscourseRoute from "discourse/routes/discourse";

export default class PracticeMatchingRoute extends DiscourseRoute {
  model() {
    return ajax("/api/practice-matching").catch(() => {
      return {
        practice_interests: [],
        practice_matches: [],
      };
    });
  }

  setupController(controller, model) {
    controller.setProperties({
      practiceInterests: model.practice_interests || [],
      practiceMatches: model.practice_matches || [],
    });
  }
}
