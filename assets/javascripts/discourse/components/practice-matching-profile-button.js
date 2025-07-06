import Component from "@glimmer/component";
import { service } from "@ember/service";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

export default class PracticeMatchingProfileButton extends Component {
  @service currentUser;
  @service toasts;
  @service siteSettings;
  @tracked isLoading = false;
  @tracked hasInterest = false;

  get userModel() {
    // 兼容@model和@user
    return this.args.model || this.args.user;
  }

  constructor() {
    super(...arguments);
    this.checkInterestStatus();
  }

  get showButton() {
    // 只对登录用户显示，不能对自己显示
    return (
      this.currentUser &&
      this.userModel &&
      this.currentUser.id !== this.userModel.id &&
      this.siteSettings.practice_matching_enabled
    );
  }

  get buttonText() {
    if (this.hasInterest) {
      return i18n("practice_matching.already_interested");
    }
    return i18n("practice_matching.add_interest");
  }

  get buttonClass() {
    if (this.hasInterest) {
      return "btn btn-default practice-interest-btn already-interested";
    }
    return "btn btn-primary practice-interest-btn";
  }

  get buttonIcon() {
    if (this.hasInterest) {
      return "heart";
    }
    return "heart";
  }

  async checkInterestStatus() {
    if (!this.showButton) return;

    try {
      const result = await ajax("/api/practice-matching");
      if (result && result.practice_interests && this.userModel) {
        this.hasInterest = result.practice_interests.some(
          user => user.id === this.userModel.id
        );
      }
    } catch (error) {
      console.error("Error checking interest status:", error);
    }
  }

  @action
  async toggleInterest() {
    if (this.isLoading || !this.userModel) return;

    this.isLoading = true;

    try {
      if (this.hasInterest) {
        // 移除兴趣
        const result = await ajax("/api/practice-matching/remove", {
          type: "DELETE",
          data: { username: this.userModel.username }
        });

        if (result && result.success) {
          this.hasInterest = false;
          this.toasts.success({
            duration: 3000,
            data: { message: result.message || i18n("practice_matching.messages.interest_removed", { username: this.userModel.username }) }
          });
        }
      } else {
        // 添加兴趣
        const result = await ajax("/api/practice-matching/add", {
          type: "POST",
          data: { username: this.userModel.username }
        });

        if (result && result.success) {
          this.hasInterest = true;
          this.toasts.success({
            duration: 3000,
            data: { message: result.message || i18n("practice_matching.messages.interest_added", { username: this.userModel.username }) }
          });
        }
      }
    } catch (error) {
      console.error("Error toggling interest:", error);
      let errorMessage = i18n("practice_matching.errors.operation_failed");
      
      if (error.jqXHR && error.jqXHR.responseJSON) {
        errorMessage = error.jqXHR.responseJSON.error || errorMessage;
      }
      
      this.toasts.error({
        duration: 5000,
        data: { message: errorMessage }
      });
    } finally {
      this.isLoading = false;
    }
  }
} 