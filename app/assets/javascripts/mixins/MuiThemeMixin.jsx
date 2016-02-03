"use strict"
var mui = require("material-ui");
var ThemeManager = require('material-ui/lib/styles/theme-manager');
var HoneycombTheme = require("../themes/HoneycombTheme");

var MuiThemeMixin = {
  childContextTypes: {
    muiTheme: React.PropTypes.object
  },

  getChildContext() {
    return {
      muiTheme: ThemeManager.getMuiTheme(HoneycombTheme)
    };
  },
};

module.exports = MuiThemeMixin;
