import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";

export default class PracticeMatchingRoute extends DiscourseRoute {
  model() {
    return ajax("/practice-matching").catch(error => {
      console.error("Error loading practice matching data:", error);
      return {
        practice_interests: [],
        practice_targets: [],
        practice_matches: []
      };
    });
  }

  setupController(controller, model) {
    controller.setProperties({
      practiceInterests: model.practice_interests || [],
      practiceTargets: model.practice_targets || [],
      practiceMatches: model.practice_matches || []
    });
  }

  async addInterest(username) {
    try {
      const result = await ajax("/practice-matching/add", {
        type: "POST",
        data: { username }
      });
      
      if (result.success) {
        // 刷新数据
        this.refresh();
      }
      
      return result;
    } catch (error) {
      console.error("Error adding interest:", error);
      throw error;
    }
  }

  async removeInterest(username) {
    try {
      const result = await ajax("/practice-matching/remove", {
        type: "POST",
        data: { username }
      });
      
      if (result.success) {
        // 刷新数据
        this.refresh();
      }
      
      return result;
    } catch (error) {
      console.error("Error removing interest:", error);
      throw error;
    }
  }
} 