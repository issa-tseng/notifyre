$(function()
{
    var isSignup = true;
    $('.signinToggleLink').click(function(event)
    {
        event.preventDefault();

        if (isSignup)
        {
            $('.signinToggleLink').text('Don\'t have an account yet?');
            $('.signinSection').slideDown();
            $('.signupSection').slideUp();
            $('form').attr('action', '/signin');
        }
        else
        {
            $('.signinToggleLink').text('Already have an account?');
            $('.signinSection').slideUp();
            $('.signupSection').slideDown();
            $('form').attr('action', '/signup');
        }
        isSignup = !isSignup;
    });
});
