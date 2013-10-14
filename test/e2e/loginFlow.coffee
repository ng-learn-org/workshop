describe "Login Flow", ->

  beforeEach ->
    browser().navigateTo "/"

  it "should land at the login page", ->
    expect(browser().location().url()).toBe "/login"