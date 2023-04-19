import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle"];

  connect() {
    this.startPolling();
  }

  disconnect() {
    this.stopPolling();
  }

  startPolling() {
    this.polling = true;
    this.refreshInterval = setInterval(() => {
      this.refresh();
    }, 10000); // Poll every 10 seconds
  }

  stopPolling() {
    this.polling = false;
    clearInterval(this.refreshInterval);
  }

  togglePolling() {
    if (this.polling) {
      this.stopPolling();
    } else {
      this.startPolling();
    }
  }

  async refresh() {
    const response = await fetch(window.location.href, {
      headers: { "Accept": "text/vnd.turbo-stream.html" },
    });
    const turboStream = await response.text();
    Turbo.renderStreamMessage(turboStream);
  }
}
