import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle"];
  static values = {
    intervalMilliseconds: Number
  }

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
    }, this.intervalMillisecondsValue);
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
