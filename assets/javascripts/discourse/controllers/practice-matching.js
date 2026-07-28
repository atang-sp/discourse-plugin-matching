import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { avatarUrl } from "discourse/lib/avatar-utils";
import { i18n } from "discourse-i18n";
import PracticeMatchingUserSelector from "discourse/plugins/discourse-plugin-matching/discourse/components/practice-matching-user-selector";

function responseErrorMessage(error, fallback) {
  const response = error?.jqXHR?.responseJSON || error?.responseJSON;
  if (response?.error) {
    return response.error;
  }

  const responseText = error?.jqXHR?.responseText || error?.responseText;
  if (responseText) {
    try {
      return JSON.parse(responseText).error || fallback;
    } catch {
      return fallback;
    }
  }

  return error?.message || fallback;
}

export default class PracticeMatchingController extends Controller {
  @service router;
  @service modal;
  @service store;
  @service toasts;

  @tracked isSearching = false;
  @tracked searchResults = [];

  practiceMatches = [];
  practiceInterests = [];

  @action
  getAvatarUrl(avatarTemplate) {
    return avatarUrl(avatarTemplate, "medium");
  }

  @action
  async addInterest() {
    this.modal.show(PracticeMatchingUserSelector, {
      model: {
        onSelect: (username) => this.handleUserSelection(username),
      },
    });
  }

  @action
  async handleUserSelection(username) {
    if (!username) {
      return;
    }

    try {
      const result = await ajax("/api/practice-matching/add", {
        type: "POST",
        data: { username },
      });

      if (result?.success) {
        this.modal.close();
        this.toasts.success({
          duration: 3000,
          data: {
            message:
              result.message ||
              i18n("practice_matching.messages.interest_added", { username }),
          },
        });
        this.send("refreshModel");
      } else {
        this.toasts.error({
          duration: 3000,
          data: { message: i18n("practice_matching.errors.add_failed") },
        });
      }
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: {
          message: responseErrorMessage(
            error,
            i18n("practice_matching.errors.add_user_failed")
          ),
        },
      });
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
        limit: 10,
      });
      this.searchResults = users.toArray();
    } catch {
      this.searchResults = [];
    } finally {
      this.isSearching = false;
    }
  }

  @action
  async removeInterest(username) {
    try {
      const result = await ajax("/api/practice-matching/remove", {
        type: "DELETE",
        data: { username },
      });

      if (result?.success) {
        this.toasts.success({
          duration: 3000,
          data: {
            message:
              result.message ||
              i18n("practice_matching.messages.interest_removed", { username }),
          },
        });
        this.send("refreshModel");
      } else {
        this.toasts.error({
          duration: 3000,
          data: { message: i18n("practice_matching.errors.remove_failed") },
        });
      }
    } catch (error) {
      this.toasts.error({
        duration: 3000,
        data: {
          message: responseErrorMessage(
            error,
            i18n("practice_matching.errors.remove_user_failed")
          ),
        },
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
