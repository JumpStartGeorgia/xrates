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
                    <td>name</td>
                    <td>The name of the error</td>
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
              name: "error",
              field: null,
              message: "Undocumented error"
            },
            {
              code: 1001,
              name: "invalid_field",
              field: null,
              message: "[Object] field is invalid."
            },

            ...

            {
              code: 2504,
              name: "start_date_start_point",
              field: "start_date",
              message: "The start date must occur after \'2000-01-01\'"
            }
          ]
        }</pre>')


      m.api_method_translations.create(locale: 'ka', title: 'List of Errors', content: '<p>Get a list of possible application errors.</p>
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
                    <td>name</td>
                    <td>The name of the error</td>
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
              name: "error",
              field: null,
              message: "Undocumented error"
            },
            {
              code: 1001,
              name: "invalid_field",
              field: null,
              message: "[Object] field is invalid."
            },

            ...

            {
              code: 2504,
              name: "start_date_start_point",
              field: "start_date",
              message: "The start date must occur after \'2000-01-01\'"
            }
          ]
        }</pre>')


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
        m.api_method_translations.create(locale: 'ka', title: 'Request Errors', content: '<p>An API request that cannot be processed will respond as a JSON object listing the errors. <a href="/ka/api/v1/documentation/errors">Explore the list of possible errors here</a>.</p>
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
