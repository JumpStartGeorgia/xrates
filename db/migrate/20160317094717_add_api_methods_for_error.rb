class AddApiMethodsForError < ActiveRecord::Migration
  def up
    puts "Creating API Methods For 'List of errors' and 'Request errors'"
    v = ApiVersion.by_permalink('v1')
    if v.present?
      m = v.api_methods.create(permalink: 'errors', sort_order: 7, public: true)
      m.api_method_translations.create(locale: 'en', title: 'List of Errors', content: '<p>Get a list of possible application errors.</p>
        <h2>URL</h2>
        <p>To call this method, use an HTTP GET request to the following URL:</p>
        <div class="url">http://lari.jumpstart.ge/[locale]/api/v1/errors</div>
        <p>where:</p>
        <ul class="list-unstyled">
            <li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
        </ul>
        <h2>Required Parameters</h2>
        <p>There are no required parameters for this call. </p>
        <h2>Optional Parameters</h2>
        <p>There are no optional parameters for this call. </p>
        <h2>What You Get</h2>
        <p>The return object is a JSON array of errors in "results" property with the following information:</p>
        <table class="table table-bordered table-hover table-nonfluid">
            <thead>
                <tr>
                    <th>Parameter</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>code</td>
                    <td>The code of the error</td>
                </tr>
                <tr>
                    <td>field</td>
                    <td>The field on which the error occurred. Possible values are null, the name of one or more fields separated by a comma.</td>
                </tr>
                <tr>
                    <td>message</td>
                    <td>Message that describes the error</td>
                </tr>
            </tbody>
        </table>
        <h2>Example</h2>
        <p>Here is an example of getting all errors.</p>
        <div class="url"><a href="/en/api/v1/errors" target="_blank">http://lari.jumpstart.ge/en/api/v1/errors</a></div>
        <pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">
        {
          valid: true,
          results: [
            {
              code: 1000,
              field: null,
              message: "Undocumented error"
            },
            {
              code: 1001,
              field: null,
              message: "[Object] field is invalid."
            },

            ...

            {
              code: 2504,
              field: "start_date",
              message: "The start date must occur after \'2000-01-01\'"
            }
          ]
        }</pre>')


      m.api_method_translations.create(locale: 'ka', title: 'ხარვეზების ჩამონათვალი', content: '<p>აპლიკაციის შესაძლო ხარვეზების ჩამონათვალის მიღება.</p>
        <h2>URL</h2>
        <p>ამ მეთოდის გამოსაძახებლად გამოიყენეთ HTTP GET მოთხოვნა შემდეგი ბმულისთვის:</p>
        <div class="url">http://lari.jumpstart.ge/[locale]/api/v1/errors</div>
        <p>სადაც:</p>
        <ul class="list-unstyled">
          <li>[locale] = ენა, რომელშიც გსურთ მონაცემების მიღება (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
        </ul>
        <h2><strong>აუცილებელი პარამეტრები</strong></h2>
        <p>გამოძახებისთვის არ არის საჭირო აუცილებელი პარამეტრები.</p>
        <h2><strong>არჩევითი პარამეტრები</strong></h2>
        <p>გამოძახებისთვის არ არის საჭირო არჩევითი პარამეტრები.</p>
        <h2><strong>რას მიიღებთ</strong></h2>
        <p>დაბრუნებული ობიექტი იქნება ხარვეზების ჩამონათვალის JSON მასივი შემდეგი ინფორმაციით:</p>
        <table class="table table-bordered table-hover table-nonfluid">
          <thead>
            <tr>
              <th>პარამეტრი</th>
              <th>აღწერა</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>code</td>
              <td>ხარვეზის კოდი</td>
            </tr>
            <tr>
              <td>field</td>
              <td>ველი, სადაც დაფიქსირდა ხარვეზი. შესაძლო მნიშვნელობებია ნული, ან ერთმანეთისგან მძიმით გამოყოფილი ერთი ან მეტი ველის სახელი.</td>
            </tr>
            <tr>
            <td>message</td>
            <td>გზავნილი, რომელიც აღწერს ხარვეზს.</td>
            </tr>
          </tbody>
        </table>
        <h2>მაგალითი</h2>
        <p>ეს არის ყველა შესაძლო ხარვეზის მიღების მაგალითი:</p>
        <div class="url">
        <a href="/ka/api/v1/errors" target="_blank">http://lari.jumpstart.ge/ka/api/v1/errors</a>
        </div>
        <pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">
        {
          valid: true,
          results: [
            {
              code: 1000,
              field: null,
              message: "გაუთვალისწინებელი ხარვეზი"
            },
            {
              code: 1001,
              field: null,
              message: "[Object] ველი არასწორია"
            },

            ...

            {
              code: 2504,
              field: "start_date",
              message: "საწყისი თარიღი უნდა იყოს \'2000-01-01\'-ის შემდეგ"
            }
          ]
        }</pre>
        ')


       m = v.api_methods.create(permalink: 'request_errors', sort_order: 8, public: true)
        m.api_method_translations.create(locale: 'en', title: 'Request Errors', content: '<p>An API request that cannot be processed will respond as a JSON object listing the errors. <a href="/en/api/v1/documentation/errors">Explore the list of possible errors here</a>.</p>
          <h2>What You Get</h2>
          <p>The return object is a JSON object with the following information:</p>
          <table class="table table-bordered table-hover table-nonfluid">
              <thead>
                  <tr>
                      <th>Parameter</th>
                      <th>Description</th>
                  </tr>
              </thead>
              <tbody>
                  <tr>
                      <td>valid</td>
                      <td>Indicates the state of request. Possible values are true or false. If request was processed without an error then true is set, else false. You need to check the errors property to find the reason.</td>
                  </tr>
                  <tr>
                      <td>errors</td>
                      <td>Array of errors that was raised while processing the request</td>
                  </tr>
              </tbody>
          </table>
          <p><b>Errors</b> properties are:</p>
          <table class="table table-bordered table-hover table-nonfluid">
              <thead>
                  <tr>
                      <th>Parameter</th>
                      <th>Description</th>
                  </tr>
              </thead>
              <tbody>
                  <tr>
                      <td>code</td>
                      <td>The code of the error</td>
                  </tr>
                  <tr>
                      <td>field</td>
                      <td>The field on which the error occurred. Possible values are null, the name of one or more fields separated by a comma.</td>
                  </tr>
                  <tr>
                      <td>message</td>
                      <td>Message that describes the error</td>
                  </tr>
              </tbody>
          </table>
          <h2>Example</h2>
          <p>Here is an example of an erroneous request. The start_date should be less than end_date, otherwise an error will occur.</p>
          <div class="url"><a href="/en/api/v1/nbg_rates?currency=USD&start_date=1458072000000&end_date=1456776000000" target="_blank">http://lari.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&start_date=1458072000000&end_date=1456776000000</a></div>
          <pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">
          {
            valid: false,
            errors: [
              {
                code: 2503,
                field: "start_date,end_date",
                message: "Please make sure the start date is less than the end date"
              }
            ]
          }</pre>
          ')
        m.api_method_translations.create(locale: 'ka', title: 'მოთხოვნის ხარვეზები', content: '<p>API-ის მოთხოვნაზე, რომელიც ვერ დამუშავდება, პასუხად მიიღებთ ხარვეზების ჩამონათვალს JSON-ის ობიექტის სახით. <a href="/ka/api/v1/documentation/errors">შესაძლო ხარვეზების ჩამონათვალი ნახეთ აქ.</a></p>
          <h2>რას მიიღებთ</h2>
          <p>დაბრუნებული შედეგი არის JSON ობიექტი შემდეგი ინფორმაციით:</p>
          <table class="table table-bordered table-hover table-nonfluid">
            <thead>
              <tr>
                <th>პარამეტრი</th>
                <th>აღწერა</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>valid</td>
                <td>მიუთითებს მოთხოვნის სტადიას. შესაძლო მნიშვნელობებია true ან false. თუ მოთხოვნა დამუშავდა ხარვეზის გარეშე, მიიღებთ true-ს, წინააღმდეგ შემთხვევაში - false-ს. თქვენ უნდა შეამოწმოთ ხარვეზის მახასიათებლები მიზეზის დასადგენად.</td>
              </tr>
              <tr>
                <td>errors</td>
                <td>მოთხოვნის დამუშავებისას წარმოქმნილი ხარვეზების ჩამონათვალი</td>
              </tr>
            </tbody>
          </table>
          <p><strong>ხარვეზის</strong> მახასიათებლებლია:</p>
          <table class="table table-bordered table-hover table-nonfluid">
            <thead>
              <tr>
                <th>პარამეტრი</th>
                <th>აღწერა</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>code</td>
                <td>ხარვეზის კოდი</td>
              </tr>
              <tr>
                <td>field</td>
                <td>ველი, სადაც დაფიქსირდა ხარვეზი. შესაძლო მნიშვნელობებია ნული, ან ერთმანეთისგან მძიმით გამოყოფილი ერთი ან მეტი ველის სახელი.</td>
              </tr>
              <tr>
                <td>message</td>
                <td>გზავნილი, რომელიც აღწერს ხარვეზს.</td>
              </tr>
            </tbody>
          </table>
          <h2>მაგალითი</h2>
          <p>მოთხოვნის ხარვეზის მაგალითი:</p>
          <h2>start_date არ უნდა აღემატებოდეს end_date-ს, წინააღმდეგ შემთხვევაში, დაფიქსირდება ხარვეზი.</h2>
          <div class="url">
            <a href="/ka/api/v1/nbg_rates?currency=USD&start_date=1458072000000&end_date=1456776000000" target="_blank">http://lari.jumpstart.ge/ka/api/v1/nbg_rates?currency=USD&amp;start_date=1458072000000&amp;end_date=1456776000000</a>
          </div>
          <pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">          
            {
              valid: false,
              errors: [
                {
                  code: 2503,
                  field: "start_date,end_date",
                  message: "გთხოვთ დარწმუნდეთ, რომ საწყისი თარიღი დასრულების თარიღზე ნაკლებია"
                }
              ]
            }
          </pre>')
    end
  end


  def down
    puts "Reverting API Methods For 'List of errors' and 'Request errors'"
    v = ApiVersion.by_permalink('v1')
    if v.present?
      m = ApiMethod.by_permalink(v.id, "errors")
      m.destroy if m.present?
      m = ApiMethod.by_permalink(v.id, "request_errors")
      m.destroy if m.present?
    end
  end
end
