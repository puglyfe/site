selectors = {
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

TweenLite.set($refs.projectTitle, {left: '50%', top: '50%', x: '-50%', y: '-50%'})

bindEscape = () ->
  $(document).on 'keyup.attachEscape', (e) ->
    if (e.keyCode == 27)
      $refs.contextToggle.click()
      $(document).off 'keyup.attachEscape'

$refs.projectTitle.click ->
  $title = $(this)
  $project = $title.closest(selectors.project)
  $info = $title.closest(selectors.projectInfo)

  infoStyles = window.getComputedStyle($info.get(0))
  offset = {
    top: infoStyles.getPropertyValue('padding-top'),
    left: infoStyles.getPropertyValue('padding-left')
  }

  bindEscape()
  $project.addClass('project-card--open').find('.project-card__image-container').scrollTop(0)
  $('body').removeClass('bio-active').addClass('project-active')
  TweenLite.to($title, animationProps.duration.med, {left: offset.left, top: offset.top, x: '0%', y: '0%'})

$refs.contextToggle.click ->
  $this = $(this)
  $body = $('body')

  # remove any existing ESC bindings
  $(document).off 'keyup.attachEscape'

  if $body.hasClass('project-active')
    # close project, center titles
    $body.removeClass('project-active')
    $(selectors.project).removeClass('project-card--open')
    TweenLite.to($refs.projectTitle, animationProps.duration.med, {left: '50%', top: '50%', x: '-50%', y: '-50%'})
  else if $body.hasClass('bio-active')
    # close bio, center titles
    $body.removeClass('bio-active')
    TweenLite.to($refs.projectTitle, animationProps.duration.med, {top: '50%'});
  else
    # open bio, move titles.
    bindEscape()
    $body.addClass('bio-active')
    TweenLite.to($refs.projectTitle, .35, {top: $refs.projectInfo.css('padding-top')})

$refs.email.click ->
  window.location.href = 'mailto:ctpugmire@gmail.com';
