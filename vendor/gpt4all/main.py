from gpt4all import GPT4All
import re
import pika
import json

connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))

channel = connection.channel()

channel.queue_declare(queue='rpc_queue')

def extract_expenses(n):
    model = GPT4All("Meta-Llama-3-8B-Instruct.Q4_0.gguf", n_ctx=4098)
    prompt = 'You are a financial analyst. The input below is a transcription of a bank statement. It contains information about amounts paid and due, caracteristics of the account, rates and transactions. You are required to filter daily expenses and ignore the rest of the information. The daily expenses filtered should contain date of transaction, name of the merchant and value of the transaction. Here is the text to be analysed: %s' % n
    response = ""
    with model.chat_session():
        model.generate(prompt, max_tokens=2048)
        r = model.generate("Your next job is to convert the list of expenses in JSON format. Each expense must have the following keys: date, description and value. Value must be a number, without any symbol. The collection of expenses must be enclosed in an array, represented by square brackets.", max_tokens=1024)
        m = re.search("\[(\n|\s|\S|\")*\]", r)
        response = m.group()
    return response

def on_request(ch, method, props, body):
    print('Processing RPC request for %s' % props.correlation_id)
    response = extract_expenses(body)
    ch.basic_publish(exchange='',
                     routing_key=props.reply_to,
                     properties=pika.BasicProperties(correlation_id = props.correlation_id),
                     body=str(response))
    ch.basic_ack(delivery_tag=method.delivery_tag)
    print('Done for %s' % props.correlation_id)

channel.basic_qos(prefetch_count=1)
channel.basic_consume(queue='rpc_queue', on_message_callback=on_request)

print("RPC server started, waiting RPC requests...")
channel.start_consuming()
