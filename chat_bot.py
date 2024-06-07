from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer

# Create a new chatbot
bot = ChatBot('MyBot')

# Create a new trainer for the chatbot
trainer = ChatterBotCorpusTrainer(bot)

# Train the chatbot on the English language
trainer.train('chatterbot.corpus.english')

# Simple interaction loop
print("Hello! I'm your chatbot. Type 'exit' to end the conversation.")
while True:
    user_input = input("You: ")
    
    # Exit the loop if the user types 'exit'
    if user_input.lower() == 'exit':
        print("Goodbye!")
        break
    
    # Get the chatbot's response
    response = bot.get_response(user_input)
    
    print(f"Bot: {response}")
