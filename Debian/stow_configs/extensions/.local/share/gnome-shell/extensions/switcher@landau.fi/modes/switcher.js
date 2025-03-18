const St = imports.gi.St;
const Clutter = imports.gi.Clutter;
const Main = imports.ui.main;
const Shell = imports.gi.Shell;
const Meta = imports.gi.Meta;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const Convenience = Me.imports.convenience;

const util = Me.imports.util;
const modeUtils = Me.imports.modes.modeUtils.ModeUtils;

var onlyCurrentWorkspaceToggled = false;

var Switcher = (function() {
  // Limit the number of displayed items
  const MAX_NUM_ITEMS = 15;

  let name = function() {
    return 'Switcher';
  };

  let filter = function(app) {
    let onlyCurrentWorkspace = Convenience.getSettings().get_boolean(
      'only-current-workspace'
    );
    let currentWorkspace = util.getCurrentWorkspace();
    const workspace = app.get_workspace();
    const workspaceIndex = workspace ? workspace.index() : null;
    return (
        (!onlyCurrentWorkspace && !onlyCurrentWorkspaceToggled) ||
        (onlyCurrentWorkspace && onlyCurrentWorkspaceToggled) ||
        workspaceIndex === currentWorkspace
    );
  };

  let activate = function(app) {
    Main.activateWindow(app);
  };

  let apps = function() {
    // Get all windows in activation order
    let tabList = global.display.get_tab_list(Meta.TabList.NORMAL, null);

    return tabList.map(tab => ({ app: tab, mode: Switcher, activate }));
  };


  let description = function(app) {
    let workspace = '';
    if (Convenience.getSettings().get_boolean('workspace-indicator')) {
      try {
        workspace = app.get_workspace().index() + 1 + ': ';
      } catch (e) {
        print(e);
      }
    }

    const appRef = Shell.WindowTracker.get_default().get_window_app(app);
    let appName;
    try {
      appName = appRef.get_name().replace(/&/g, '&amp;');
    } catch (e) {
      print(e);
      appName = 'Could not get name';
    }

    return workspace + appName + ' → ' + app.get_title() + ` ${modeUtils.getExtras(appRef)}`;
  };

  let makeBox = function(appObj, index, onActivate, oldBox) {
    const app = appObj.app;
    const appRef = Shell.WindowTracker.get_default().get_window_app(app);
    if (!appRef) return null;
    return modeUtils.makeBox(
      appObj,
      app,
      appRef,
      description(app),
      index,
      onActivate,
      oldBox
    );
  };

  return {
    MAX_NUM_ITEMS,
    name,
    apps,
    filter,
    activate,
    description,
    makeBox,
    cleanIDs: modeUtils.cleanIDs
  };
})();
