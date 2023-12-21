from flask import Flask, render_template, request
import openai

app = Flask(__name__)

# Set up OpenAI API credentials
openai.api_key = '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'
# Define the default route to return the index.html file
@app.route("/")
def index():
    return render_template("index.html")

# Define the /api route to handle POST requests
@app.route("/api", methods=["POST"])
def api():
    # Get the message from the POST request
    user_message = request.json.get("message")
    
    # Define a system message to set context as medical
    system_message = {"role": "system", "content": "You are strictly a NGOs (Non-Governmental Organizations) chatbot. Do not provide information outside of the NGOs (Non-Governmental Organizations) domain. If a question isn't NGOs (Non-Governmental Organizations), inform the user and ask for a NGOs (Non-Governmental Organizations) question."}
    
    # Send the system message and user message to OpenAI's API and receive the response
    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            system_message,
            {"role": "user", "content": user_message}
        ]
    )
    
    response = completion.choices[0].message
    return response

if __name__ == '__main__':
    app.run()