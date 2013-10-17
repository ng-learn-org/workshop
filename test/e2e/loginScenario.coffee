describe "Login Flow", ->

  beforeEach ->
    browser().navigateTo "/"
    pause()

  it "should be the first page", ->
    expect(element("h1").text()).toBe "Login"
