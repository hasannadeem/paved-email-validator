import consumer from "./consumer"

const assignColor = (data, result_id, ele_id) => {
  if (data.result[result_id]) {
    document.getElementById(ele_id).classList.toggle('bg-green-600')
  }
  else {
    document.getElementById(ele_id).classList.toggle('bg-red-600')
  }
}

consumer.subscriptions.create("DataChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
    document.getElementById("spf-dkim-auth").innerText = data.result['valid_dkim_spf'];
    assignColor(data, 'valid_dkim_spf', "spf-dkim-auth");
    document.getElementById("dns-records-validation").innerText = data.result['valid_dns_records'];
    assignColor(data, 'valid_dns_records', "dns-records-validation");
    document.getElementById("tls-verification").innerText = data.result['tls_verification'];
    assignColor(data, 'tls_verification', "tls-verification");
    document.getElementById("message-format-validation").innerText = data.result['message_format_validation'];
    assignColor(data, 'message_format_validation', "message-format-validation");
    document.getElementById("unsub-link").innerText = data.result['unsubscribe_link_present'];
    assignColor(data, 'unsubscribe_link_present', "unsub-link");
    document.getElementById("dmarc-email-auth").innerText = data.result['dmarc_authenticated'];
    assignColor(data, 'dmarc_authenticated', "dmarc-email-auth");
    document.getElementById("email-address").innerText = "Email: " + data.result['email_address'];
  }
});
