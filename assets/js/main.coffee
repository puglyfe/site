selectors = {
  contextToggle: '.js-context-toggle',
  projectInfo: '.js-project-info',
  projectOpen: '.js-project-open',
  projectTitle: '.js-project-title',
  email: '.js-email'
};

$refs = Object.keys(selectors).reduce(((obj, current) ->
  obj[current] = $(selectors[current])
  obj
), {})

TweenLite.set($refs.projectTitle, {left: '50%', top: '50%', x: '-50%', y: '-50%'})

$refs.projectOpen.click ->
  console.log('openProject')
  $this = $(this)
  $info = $this.find(selectors.projectInfo)
  $title = $this.find(selectors.projectTitle)

  infoStyles = window.getComputedStyle($info.get(0))
  offset = {
    top: infoStyles.getPropertyValue('padding-top'),
    left: infoStyles.getPropertyValue('padding-left')
  }

  $this.addClass('project-card--open')
  $('body').removeClass('bio-active').addClass('project-active')
  TweenLite.to($title, .35, {left: offset.left, top: offset.top, x: '0%', y: '0%'})

$refs.contextToggle.click ->
  console.log('toggleNav')
  $this = $(this)
  $body = $('body')
  if $body.hasClass('project-active')
    $body.removeClass('project-active')
    $(selectors.projectOpen).removeClass('project-card--open')
    TweenLite.to($refs.projectTitle, .35, {left: '50%', top: '50%', x: '-50%', y: '-50%'})
  else if $body.hasClass('bio-active')
    $body.removeClass('bio-active')
    TweenLite.to($refs.projectTitle, .35, {top: '50%'})
  else
    $body.addClass('bio-active')
    TweenLite.to($refs.projectTitle, .35, {top: $refs.projectInfo.css('padding-top')})

$refs.email.click ->
  console.log('email');
  window.location.href = 'mailto:ctpugmire@gmail.com';
