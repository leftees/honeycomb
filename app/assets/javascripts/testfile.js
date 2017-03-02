import * as $ from 'jquery';
import {configuration} from '../configuration/environment';
import { Manager as SessionManager } from 'perk-oauth2/session';

/**
 * Runtime cycle.
 *
 * @param   {angular.IModule}   application
 */
export default (application: angular.IModule): void => {
  application.run(
    [
      '$rootScope',
      '$window',
      '$state',
      'authenticated',
      'SessionManagerSDK',
      (
        $rootScope: angular.IRootScopeService | any,
        $window: angular.IWindowService | Window,
        $state: angular.ui.IStateService,
        authenticated: boolean,
        sessionManagerSDK: SessionManager
      ): void => {
        $rootScope.authenticated    = authenticated;
        $rootScope.chromeIdentifier = configuration.extension.chrome.identifier;
        $rootScope.$on(
          '$stateChangeStart',
          (
            event: angular.IAngularEvent | any,
            toState: angular.ui.IState | any,
            toParams: angular.ui.IStateParamsService | any,
            fromState: angular.ui.IState,
            fromParams: angular.ui.IStateParamsService | any,
            options
          ): void => {
            const toSettings: {} | any = typeof toState.settings === 'undefined' ? {} : toState.settings;

            if (
                event.currentScope.authenticated === false &&
                (!toSettings.hasOwnProperty('authenticated') ||
                (toSettings.hasOwnProperty('authenticated') && toSettings.authenticated === true))
            ) {
              event.preventDefault();

              $state.go('landing', {'redirectState': toState.name});
            }
          }
        );

        $rootScope.$on(
          '$stateChangeSuccess',
          (
            event: angular.IAngularEvent | any,
            toState: angular.ui.IState | any,
            toParams: angular.ui.IStateParamsService | any,
            fromState: angular.ui.IState,
            fromParams: angular.ui.IStateParamsService | any,
            options
          ): void => {
            // Set scroll to top, fix https://app.asana.com/0/163200385483458/271727516872229.
            $('body').scrollTop(0);

            // Push a Piwik Analytics event on a state change success.
            $window._paq.push(['trackPageView']);
          }
        );

        /**
         * Checks for active user session on user's click event
         */
        window.addEventListener('click', (): void => {
          if ($rootScope.authenticated) {
            (<Q.Promise<any>>sessionManagerSDK.session()).catch(() => {
              window.location.href = '/';
            });
          } else {
            (<Q.Promise<any>>sessionManagerSDK.session()).then(() => {
              window.location.href = '/home';
            });
          }
        });
      }
    ]
  );

  // Bootstrap!
  angular.bootstrap(document, [application.name]);
};
