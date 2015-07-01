angular.module('directives.flipside', [])
.directive 'flipside', () ->
  restrict: 'E'
  transclude: true
  templateUrl: 'directives/flipside.tpl.html'
  scope:
    title: '@'
  link: (scope, elem, attrs) ->
    btn = elem[0].querySelector '.flipside-btn'
    btnFront = btn.querySelector '.flipside-btn-front'
    btnNo = btn.querySelector '.flipside-btn-no'
    btnLink = btn.querySelector('.flipside-link')
    btnFront.addEventListener 'click', (event) ->
      mx = event.clientX - btn.offsetLeft
      my = event.clientY - btn.offsetTop
      w = btn.offsetWidth
      h = btn.offsetHeight
      directions = [
        {id: 'top', x: w / 2, y: 0},
        {id: 'right', x: w, y: h / 2},
        {id: 'bottom', x: w / 2, y: h},
        {id: 'left', x: 0, y: h / 2}
      ]

      directions.sort (a, b) -> distance(mx, my, a.x, a.y) - distance(mx, my, b.x, b.y)

      btn.setAttribute 'data-direction', directions.shift().id
      btn.classList.add 'is-open'

    btnLink.addEventListener 'click', -> btn.classList.remove 'is-open'
    btnNo.addEventListener 'click', -> btn.classList.remove 'is-open'

    distance = (x1, y1, x2, y2) ->
      dx = x1 - x2
      dy = y1 - y2
      Math.sqrt(dx * dx + dy * dy)


