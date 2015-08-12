/**
 * Created by mikey on 7/7/15.
 */
//= require_self
//= require_tree ./angular

var app = angular.module('app', ['ngResource', 'ngRoute']);

app.factory('GetPost', ['$resource', function ($resource) {
  return $resource('/main/getPost');
}]);

app.factory('GetWeights', ['$resource', function ($resource) {
  return $resource('/main/getWeights');
}]);

app.factory('SignIn', ['$resource', function ($resource) {
  return $resource('/main/signIn');
}]);

app.factory('SubmitPost', ['$resource', function ($resource) {
  return $resource('/main/submit');
}]);