import Controller from "@ember/controller";
import { inject as service } from "@ember/service";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { avatarUrl } from "discourse/lib/avatar-utils";
import { getOwner } from "@ember/application";
import PracticeMatchingUserSelector from "discourse/plugins/discourse-plugin-matching/discourse/components/practice-matching-user-selector";

export default class PracticeMatchingController extends Controller {
  @service router;
  @service modal;
  @service store;
  @service toasts;

  practiceInterests = [];
  practiceTargets = [];
  practiceMatches = [];
  @tracked selectedUsername = "";
  @tracked searchResults = [];
  @tracked isSearching = false;

  @action
  getAvatarUrl(avatarTemplate) {
    return avatarUrl(avatarTemplate, "medium");
  }

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
      console.log("Adding user to practice interests:", username);
      try {
        console.log("Sending AJAX request to /api/practice-matching/add");
        console.log("Request data:", { username });
        const result = await ajax("/api/practice-matching/add", {
          type: "POST",
          data: { username }
        });
        
        console.log("Add interest result:", result);
        console.log("Result type:", typeof result);
        console.log("Result is null/undefined:", result == null);
        console.log("Result keys:", result ? Object.keys(result) : "N/A");
        console.log("Result success:", result.success);
        
        if (result && typeof result === 'object' && result.success) {
          this.modal.close();
          console.log("Result success1111:", result.success);
          // 显示成功消息
          this.toasts.success({
            duration: 3000,
            data: { message: result.message || "用户已添加到实践兴趣列表" }
          });
          // 刷新数据
          this.send("refreshModel");
          console.log("Result success22222:", result.success);
        } else {
          console.warn("Unexpected result format:", result);
          // 显示错误消息
          this.toasts.error({
            duration: 3000,
            data: { message: "添加失败，请重试" }
          });
        }

        console.log("Result success33333:", result.success);
      } catch (error) {
        console.error("Error adding interest:", error);
        console.error("Error object structure:", {
          hasJqXHR: !!error.jqXHR,
          hasResponseJSON: !!error.responseJSON,
          hasResponseText: !!error.responseText,
          hasMessage: !!error.message,
          errorType: typeof error
        });
        // 显示错误消息
        let errorMessage = "添加用户失败，请重试";
        
        // 安全地处理错误对象
        if (error && typeof error === 'object') {
          // 检查 jqXHR 格式的错误
          if (error.jqXHR && error.jqXHR.responseJSON && error.jqXHR.responseJSON.error) {
            errorMessage = error.jqXHR.responseJSON.error;
          } else if (error.jqXHR && error.jqXHR.responseText) {
            try {
              const response = JSON.parse(error.jqXHR.responseText);
              if (response && response.error) {
                errorMessage = response.error;
              }
            } catch (e) {
              // 如果无法解析 JSON，使用默认消息
            }
          }
          // 检查其他可能的错误格式
          else if (error.responseJSON && error.responseJSON.error) {
            errorMessage = error.responseJSON.error;
          } else if (error.responseText) {
            try {
              const response = JSON.parse(error.responseText);
              if (response && response.error) {
                errorMessage = response.error;
              }
            } catch (e) {
              // 如果无法解析 JSON，使用默认消息
            }
          } else if (error.message) {
            errorMessage = error.message;
          }
        }
        
        this.toasts.error({
          duration: 3000,
          data: { message: errorMessage }
        });
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
      console.log("Removing user from practice interests:", username);
      const result = await ajax("/api/practice-matching/remove", {
        type: "DELETE",
        data: { username }
      });
      
      console.log("Remove interest result:", result);
      console.log("Result type:", typeof result);
      console.log("Result is null/undefined:", result == null);
      console.log("Result keys:", result ? Object.keys(result) : "N/A");
      
      if (result && typeof result === 'object' && result.success) {
        // 显示成功消息
        this.toasts.success({
          duration: 3000,
          data: { message: result.message || "用户已从实践兴趣列表中移除" }
        });
        // 刷新数据
        this.send("refreshModel");
      } else {
        console.warn("Unexpected result format for remove:", result);
        this.toasts.error({
          duration: 3000,
          data: { message: "移除失败，请重试" }
        });
      }
    } catch (error) {
      console.error("Error removing interest:", error);
      console.error("Error object structure:", {
        hasJqXHR: !!error.jqXHR,
        hasResponseJSON: !!error.responseJSON,
        hasResponseText: !!error.responseText,
        hasMessage: !!error.message,
        errorType: typeof error
      });
      // 显示错误消息
      let errorMessage = "移除用户失败，请重试";
      
      // 安全地处理错误对象
      if (error && typeof error === 'object') {
        // 检查 jqXHR 格式的错误
        if (error.jqXHR && error.jqXHR.responseJSON && error.jqXHR.responseJSON.error) {
          errorMessage = error.jqXHR.responseJSON.error;
        } else if (error.jqXHR && error.jqXHR.responseText) {
          try {
            const response = JSON.parse(error.jqXHR.responseText);
            if (response && response.error) {
              errorMessage = response.error;
            }
          } catch (e) {
            // 如果无法解析 JSON，使用默认消息
          }
        }
        // 检查其他可能的错误格式
        else if (error.responseJSON && error.responseJSON.error) {
          errorMessage = error.responseJSON.error;
        } else if (error.responseText) {
          try {
            const response = JSON.parse(error.responseText);
            if (response && response.error) {
              errorMessage = response.error;
            }
          } catch (e) {
            // 如果无法解析 JSON，使用默认消息
          }
        } else if (error.message) {
          errorMessage = error.message;
        }
      }
      
      this.toasts.error({
        duration: 3000,
        data: { message: errorMessage }
      });
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