$                 = require('zepto-browserify').$
attachFastclick   = require('fastclick')
TweenLite         = require('gsap')

selectors = {
  body: 'body',
  contextToggle: '.js-context-toggle',
  project: '.js-project',
  projectInfo: '.js-project-info',
  projectTitle: '.js-project-title',
  email: '.js-email'
}

animationProps = {
  duration: {
    short: .15,
    med: .35
  },
  easing: Power1.easeInOut
}

$refs = Object.keys(selectors).reduce(((obj, current) ->
  obj[current] = $(selectors[current])
  obj
), {})

breakpoints = {
  getActive: () ->
    return window.getComputedStyle(
      document.querySelector('html'), ':before'
    )
    .getPropertyValue('content').replace(/\"/g, '')
    .split('|');
}

init = ->
  attachFastclick(document.body)

  # for lolz
  console.log([
    '🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥',
    '🔥 ctpugmire@gmail.com 🔥',
    '🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥'
  ].join('\n'))

  console.log('💻 %cSource:', 'font-weight:bold', 'http://github.com/puglyfe/site 💻')

bindEscape = ->
  $(document).on 'keyup.attachEscape', (e) ->
    if (e.keyCode == 27)
      $refs.contextToggle.click()
      $(document).off 'keyup.attachEscape'

$refs.projectTitle.click ->
  $title = $(this)
  $project = $title.closest(selectors.project)
  $info = $title.closest(selectors.projectInfo)

  handleResize = ->
    infoStyles = window.getComputedStyle($info.get(0))
    offset = {
      top: infoStyles.getPropertyValue('padding-top'),
      left: infoStyles.getPropertyValue('padding-left')
    }

    TweenLite.to(
      $title,
      animationProps.duration.med,
      { left: offset.left, top: offset.top, x: '0%', y: '0%' }
    )

  $refs.body.removeClass('bio-active').addClass('project-active')
  $project
    .addClass('project-card--open')
    .find('.project-card__container')[0]
    .scrollTop = 0;  # scrollTop setter not available in this version of zepto :(

  bindEscape()
  handleResize()

  $(window).on 'resize.placeTitle', handleResize

$refs.contextToggle.click ->
  $this = $(this)

  # remove any existing ESC bindings
  $(document).off 'keyup.attachEscape'
  $(window).off 'resize.placeTitle'

  if $refs.body.hasClass('project-active')
    # close project, center titles
    $refs.body.removeClass('project-active')

    $(selectors.project).removeClass('project-card--open')

    TweenLite.to(
      $refs.projectTitle,
      animationProps.duration.med,
      { left: '50%', top: '50%', x: '-50%', y: '-50%' }
    )
  else if $refs.body.hasClass('bio-active')
    # close bio, center titles
    $refs.body.removeClass('bio-active')

    TweenLite.to(
      $refs.projectTitle,
      animationProps.duration.med,
      { top: '50%' }
    )
  else
    # open bio, move titles.
    bindEscape()

    $refs.body.addClass('bio-active')

    if breakpoints.getActive().indexOf('md') > -1
      TweenLite.to(
        $refs.projectTitle,
        animationProps.duration.med,
        { top: $refs.projectInfo.css('padding-top') }
      )

# Half-assed attempt to work around botz
$refs.email.click ->
  $this = $(this)
  window.location.href = 'mailto:' + [
    $this.attr('data-user'),
    $this.attr('data-domain')
  ].join('@')

init()
