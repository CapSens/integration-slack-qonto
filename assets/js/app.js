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

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
