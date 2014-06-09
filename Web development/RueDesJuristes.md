## RueDesJuristes

It is a web application offering juridic services for french societies. It allow creation, modification and liquidation of these legal entities.

It's done entirely in PHP using the Kohana framework.

This was the first time I would be working with Twig. It was a really nice experience. Development was extremely fast and I would no lie saying it has never bugged me. I did unit testing with PHPUnit and Kohana Request, which is surprisingly efficient.

[JSON](http://json.org) really saved me here! The website collects an humongous amount of data to proceed the legal formalities. User have to submit forms with around 60 inputs. All the data are serialized once using ```json_encode```. I used the ```ORM::filters``` feature to serialize the data on need.

## Improvements in the mail module

The project also permit me to upgrade [my mailing module](https://github.com/Hete/kohana-mail). I could consider it as a really nice piece of software. It has a lovely closure syntax:

```php
Mailer::factory()
    ->content_type('text/html; charset=utf-8')
    ->subject('Hey Foo!')
    ->body(Twig::factory('some/template'))
    ->send('foo@example.com');
```

It is also parsing recipient list using a nice regex, so you do not have to worry sending more personal mail to your user, even if they have non-ascii username. It the worst case, it default to his email.

## PHPUnit and self-requesting

Kohana is HMVC, which means that you can request any of your page in the execution of any internal ```Request```. This is extremly convenient when testing an application, since it generally ends up being about requesting an endpoint and asserting the new states of your data.

```php
class HomeTest extends Unittest_TestCase {

    public function testIndex() {

        $response = Request::factory('')->execute();

        $this->assertEquals(200, $response->status());
        $this->assertTag(array('tag' => 'h1', 'content' => 'Hello world!'), $response->body());
        // ...
}
```

Even the mail module is fully testable using ```Mail_Sender_Mock```. It is a nice feature that simulates a mailing driver. It speeds up considerably the testing as you don't need to wait for Sendmail.

```php
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
```

The website implements a payment solution based on PayPal. I did some work on my PayPal module, which has become a simple external ```Request``` factory. It is much more convenient this way then how it was before, since it reuses the code from Kohana.

I also improved the IPN implementation. It was a little buggy, since I never really used it, but now it is fully working and tested!

## Fixtures

Fixtures are really nicely done. I've overloaded Unittest_TestCase to add some on-the-fly ```ORM``` generators. For instance, if you need a user to test the login action:

```php
class Unittest_TestCase {

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
```

This is much better, in my opinion, than rely on ```Unittest_Database_TestCase``` for an ```ORM``` based application.

## Coverage

It is also the first time I've experienced test coverage and honestly, what an amazing tool. It pretty much analyze your code while tests are running and outputs statistics about code complexity and percentage of line execution. Untested code is likely not to work, so having a good coverage is really important.

This project shown me tools that made the development considerably faster and fun. Having not to debug was probably the best thing I've experienced so far.