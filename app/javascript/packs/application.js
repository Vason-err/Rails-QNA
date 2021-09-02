// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "./channels/cable.js"
import "jquery"
import "./answers"
import "./questions"
import "./direct_uploads"
import "@nathanvda/cocoon"
import "./votes"
import "./comment"

const jQuery = require("jquery");
// import jQuery from "jquery";
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;
Rails.start()
Turbolinks.start()
ActiveStorage.start()
