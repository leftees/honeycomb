"use strict"
let mui = require("material-ui");
let ThemeManager = new mui.Styles.ThemeManager();
let HoneycombTheme = require("../themes/HoneycombTheme");
ThemeManager.setTheme(HoneycombTheme);

let MuiThemeMixin = {
  childContextTypes: {
    muiTheme: React.PropTypes.object
  },

  getChildContext() {
    return {
      muiTheme: ThemeManager.getCurrentTheme()
    };
  },
};
module.exports = MuiThemeMixin;
