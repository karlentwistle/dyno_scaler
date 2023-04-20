import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
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
    this.refreshInterval = setInterval(() => {
      this.refresh();
    }, this.intervalMillisecondsValue);
  }

  stopPolling() {
    clearInterval(this.refreshInterval);
  }

  togglePolling(event) {
    event.preventDefault();

    if (event.target.checked) {
      this.startPolling();
    } else {
      this.stopPolling();
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
