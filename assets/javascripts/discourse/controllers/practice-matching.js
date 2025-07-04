import Controller from "@ember/controller";
import { inject as service } from "@ember/service";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import PracticeMatchingUserSelector from "discourse/plugins/discourse-plugin-matching/discourse/components/practice-matching-user-selector";

export default class PracticeMatchingController extends Controller {
  @service router;
  @service modal;
  @service store;

  practiceInterests = [];
  practiceTargets = [];
  practiceMatches = [];
  @tracked selectedUsername = "";
  @tracked searchResults = [];
  @tracked isSearching = false;

  @action
  async addInterest() {
    this.modal.show(PracticeMatchingUserSelector, {
      model: {
        onSelect: (username) => this.handleUserSelection(username)
      }
    });
  }

  @action
  async handleUserSelection(username) {
    if (username) {
      try {
        const result = await this.model.addInterest(username);
        if (result && result.success) {
          this.modal.close();
          // 刷新数据
          this.send("refreshModel");
        }
      } catch (error) {
        console.error("Error adding interest:", error);
      }
    }
  }

  @action
  async searchUsers(query) {
    if (!query || query.length < 2) {
      this.searchResults = [];
      return;
    }

    this.isSearching = true;
    try {
      const users = await this.store.find("user", {
        filter: query,
        limit: 10
      });
      this.searchResults = users.toArray();
    } catch (error) {
      console.error("Error searching users:", error);
      this.searchResults = [];
    } finally {
      this.isSearching = false;
    }
  }

  @action
  async removeInterest(username) {
    try {
      await this.model.removeInterest(username);
    } catch (error) {
      console.error("Error removing interest:", error);
    }
  }

  @action
  viewUserProfile(username) {
    this.router.transitionTo("user", username);
  }
} 