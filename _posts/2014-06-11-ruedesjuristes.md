---
title: RueDesJuristes
layout: post
---

![RueDesJuristes logo](//ruedesjuristes.com/assets/img/logo-small.png)

It is a web application offering juridic services for french societies. It allow
creation, modification and liquidation of these legal entities. Its website can
be found here at [ruedesjuristes.com](//ruedesjuristes.com).

It's done entirely in PHP using the Kohana framework.

This was the first time I would be working with Twig. It was a really nice 
experience. Development was extremely fast and I would no lie saying it has 
never bugged me. I did unit testing with PHPUnit and Kohana Request, which is 
surprisingly efficient.

I've been a little frustrated with errors handling when Twig syntax was wrong. 
When you get an error in a parsing tree and your debugger print humongous 
structure recursively, you get out of memory quite quickly. To avoid this, you 
may reduce the depth of recursion in ```Debug::dump``` by overloading it.

{% highlight php linenos %}
<?php

class Debug extends Kohana_Debug {

    /**
     * Reducing the default $depth from 10 to 2 to avoid reaching memory limit.
     */
    public static void dump($value, $length = 128, $depth = 2) {
        
        return parent::dump($value, $length, $depth);
    }
}
{% endhighlight %}

If you work with light templates, you should be fine with the default depth. It 
is something to consider only if you reach the memory limit.

[JSON](http://json.org) really saved me here! The website collects an big amount 
of data to proceed the legal formalities. User have to submit forms with around 
60 inputs. All the data are serialized once using ```json_encode```. I used the ```ORM::filters``` 
feature to serialize the data on need.

Form can also be submitted in ajax. To do so, you may use ```Request::is_ajax```
and disable template rendering by setting ```Request::$auto_render``` to ```FALSE```. 
I usually encode ```ORM_Validation_Exception``` errors if anything 
wrong happen: they are well structured and translated, so it becomes a charm to 
map errors to input!

{% highlight php linenos %}
<?php

if ($this->request->is_ajax()) {

    $this->auto_render = FALSE;

    $this->response->body(json_encode($errors));
}
{% endhighlight %}

## Improvements in the mail module

The project also permitted me to upgrade 
[my mailing module](https://github.com/Hete/kohana-mail). I could consider it as 
a really nice piece of software. It has a lovely closure syntax:

{% highlight php linenos %}
<?php

Mailer::factory()
    ->content_type('text/html; charset=utf-8')
    ->subject('Hey Foo!')
    ->body(Twig::factory('some/template'))
    ->send('foo@example.com');
{% endhighlight %}

It is also parsing recipient list using a nice regex, so you do not have to 
worry sending more personal mail to your user, even if they have non-ascii 
username. It the worst case, it defaults to his email.

Moreover, it supports attachment, so whenever you need to append a legal
document or an alternate message:

{% highlight php linenos %}
<?php

Mailer::factory()
    ->attachment($document->content, array('Content-Type' => $document->content_type))
    ->send($user->email);
{% endhighlight %}

## PHPUnit and self-requesting

Kohana is HMVC, which means that you can request any of your page in the 
execution of any internal ```Request```. This is extremly convenient when 
testing an application, since it generally ends up being about requesting an 
endpoint and asserting the new states of your data.

{% highlight php linenos %}
<?php

class HomeTest extends Unittest_TestCase {

    public function testIndex() {

        $response = Request::factory('')->execute();

        $this->assertEquals(200, $response->status());
        $this->assertTag(array('tag' => 'h1', 'content' => 'Hello world!'), $response->body());
        // ...
}
{% endhighlight %}

Even the mail module is fully testable using ```Mail_Sender_Mock```. It is a 
nice feature that simulates a mailing driver. It speeds up considerably the 
testing as you don't need to wait for Sendmail.

{% highlight php linenos %}
<?php

class HomeTest extends Unittest_TestCase {

    public function testMail() {

        $response = Request::factory('mail')
            ->method(Request::POST)
            ->values(array('email' => 'foo@example.com'))
            ->execute();

        $mail = array_pop(Mail_Sender_Mock::$history);

        $this->assertEquals('text/html', $mail->content_type());
        $this->assertContains('foo@example.com', $mail->to);
        $this->assertTag(array('tag' => 'h1', 'content' => 'Hello world!'), $mail->body());
        // ...
}
{% endhighlight %}

The website implements a payment solution based on PayPal. I did some work on my 
PayPal module, which has become a simple external ```Request``` factory. It is 
much more convenient this way then how it was before, since it reuses the code 
from Kohana.

I also improved the IPN implementation. It was a little buggy, since I never 
really used it, but now it is fully working and tested!

## Fixtures

Fixtures are really nicely done. I've overloaded Unittest_TestCase to add some 
on-the-fly ```ORM``` generators. For instance, if you need a user to test the 
login action:

{% highlight php linenos %}
<?php

class Unittest_TestCase extends Kohana_Unittest_TestCase {

    public function getUser() {

        return ORM::factory('User')
            ->values(array(
                'username' => uniqid(),
                'email' => uniqid() . '@ruedesjuristes.com',
                'password' => 'abcd1234'
            ))
            ->add('roles', ORM::factory('Role', array('name' => 'login')));
    }
}
{% endhighlight %}

Then, anytime you need a user in your tests,

{% highlight php linenos %}
<?php

public function testLogin() {

    $user = $this->getUser();
    $this->assertFalse(Auth::instance()->logged_in());

    $response = Request::factory()
        ->method(Request::POST)
        ->post(array(
            'username' => $user->username,
            'password' => 'abcd1234'
        ))->execute();

    $this->assertTrue(Auth::instance()->logged_in());
    $this->assertEquals($user->pk(), Auth::instance()->get_user()->pk());
}
{% endhighlight %}

This is much better, in my opinion, than rely on ```Unittest_Database_TestCase``` for an ```ORM``` based application.

## Coverage

It is also the first time I've experienced test coverage and honestly, what an 
amazing tool. It pretty much analyze your code while tests are running and 
outputs statistics about code complexity and percentage of line execution. 
Untested code is likely not to work, so having a good coverage is really 
important.

This project shown me tools that made the development considerably faster and 
fun. Having not to debug was probably the best thing I've experienced so far.
Also, delivering a high quality web app really changed the way I've been seeing
the development process.
