import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { avatarUrl } from "discourse/lib/avatar-utils";

export default class PracticeMatchingUserSelector extends Component {
  @service modal;

  @tracked searchQuery = "";
  @tracked searchResults = [];
  @tracked isSearching = false;
  @tracked selectedUser = null;

  @action
  getAvatarUrl(avatarTemplate) {
    return avatarUrl(avatarTemplate, "medium");
  }

  @action
  async searchUsers() {
    if (!this.searchQuery || this.searchQuery.length < 2) {
      this.searchResults = [];
      return;
    }

    this.isSearching = true;
    try {
      const result = await ajax("/u/search/users.json", {
        data: { term: this.searchQuery }
      });
      this.searchResults = result.users || [];
    } catch {
      this.searchResults = [];
    } finally {
      this.isSearching = false;
    }
  }

  @action
  selectUser(user) {
    this.selectedUser = user;
  }

  @action
  confirmSelection() {
    if (this.selectedUser) {
      this.args.model.onSelect(this.selectedUser.username);
    }
  }

  @action
  cancel() {
    this.modal.close();
  }

  @action
  onSearchInput(event) {
    this.searchQuery = event.target.value;
    this.searchUsers();
  }
}
