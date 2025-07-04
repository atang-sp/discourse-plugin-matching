import Controller from "@ember/controller";
import { inject as service } from "@ember/service";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { getOwner } from "@ember/application";
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
        const result = await ajax("/practice-matching/add", {
          type: "POST",
          data: { username }
        });
        
        if (result && result.success) {
          this.modal.close();
          // 显示成功消息
          const flashMessage = getOwner(this).lookup("service:flash-message");
          flashMessage.success(result.message || "用户已添加到实践兴趣列表");
          // 刷新数据
          this.send("refreshModel");
        }
      } catch (error) {
        console.error("Error adding interest:", error);
        // 显示错误消息
        const flashMessage = getOwner(this).lookup("service:flash-message");
        if (error.jqXHR && error.jqXHR.responseJSON && error.jqXHR.responseJSON.error) {
          flashMessage.error(error.jqXHR.responseJSON.error);
        } else {
          flashMessage.error("添加用户失败，请重试");
        }
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
      const result = await ajax("/practice-matching/remove", {
        type: "DELETE",
        data: { username }
      });
      
      if (result && result.success) {
        // 显示成功消息
        const flashMessage = getOwner(this).lookup("service:flash-message");
        flashMessage.success(result.message || "用户已从实践兴趣列表中移除");
        // 刷新数据
        this.send("refreshModel");
      }
    } catch (error) {
      console.error("Error removing interest:", error);
      // 显示错误消息
      const flashMessage = getOwner(this).lookup("service:flash-message");
      if (error.jqXHR && error.jqXHR.responseJSON && error.jqXHR.responseJSON.error) {
        flashMessage.error(error.jqXHR.responseJSON.error);
      } else {
        flashMessage.error("移除用户失败，请重试");
      }
    }
  }

  @action
  refreshModel() {
    this.router.refresh();
  }

  @action
  viewUserProfile(username) {
    this.router.transitionTo("user", username);
  }
} 