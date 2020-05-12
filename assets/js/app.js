// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import $ from "jquery";
import "bootstrap";
import toastr from "toastr";
import "select2";

toastr.options.toastClass = 'toastr';

if ($('.flash.info')[0]) {
  toastr["info"]($('.flash.info').html());
}
if ($('.flash.error')[0]) {
  toastr["error"]($('.flash.error').html());
}

$('select').select2();

const updateSlackChannelNameInput = () => {
  $('#integration_slack_channel_name').val($('#integration_slack_channel option:selected').html());
};

$('body').on('change', '#integration_slack_channel', updateSlackChannelNameInput);
updateSlackChannelNameInput();

const updateIbanSelect = () => {
  if ($('#integration_qonto_identifier').val() && $('#integration_qonto_secret_key').val()) {
    $('#integration_qonto_iban').parent("div").removeClass("d-none");

    $.ajax({
      url: "/bank_accounts",
      data: {
        identifier: $('#integration_qonto_identifier').val(),
        secret_key: $('#integration_qonto_secret_key').val()
      },
      success: function(response) {
        const anySelected = !!($('#integration_qonto_iban').val());

        response.forEach((iban) => {
          if (!$('#integration_qonto_iban').find(`option[value="${iban}"]`).length) {
            let newOption = new Option(iban, iban, !anySelected, !anySelected);

            $('#integration_qonto_iban').append(newOption).trigger('change');
          }
        });
      },
      error: function(xhr) {
        toastr.error("Erreur lors de la récupération de votre compte Qonto. Veuillez vérifier vos informations");
      }
    });
  } else {
    $('#integration_qonto_iban').parent("div").addClass("d-none");
  }
};

$('body').on('change', '#integration_qonto_identifier', updateIbanSelect);
$('body').on('change', '#integration_qonto_secret_key', updateIbanSelect);
updateIbanSelect();
