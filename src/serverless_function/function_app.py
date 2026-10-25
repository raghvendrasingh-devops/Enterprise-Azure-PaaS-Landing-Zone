"""
Enterprise Azure Function App (Serverless Event Handler)
Author: Raghvendra Singh | Lead DevSecOps Architect
"""

import azure.functions as func
import json
import logging

app = func.FunctionApp()

@app.route(route="event_handler", auth_level=func.AuthLevel.FUNCTION)
def event_handler(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("Python HTTP trigger function processed an enterprise event.")
    
    try:
        req_body = req.get_json()
    except ValueError:
        req_body = None

    if req_body:
        event_type = req_body.get('eventType', 'UNKNOWN_EVENT')
        logging.info(f"Processing event: {event_type}")
        
        return func.HttpResponse(
            json.dumps({
                "status": "SUCCESS",
                "processedEvent": event_type,
                "engine": "Azure-Functions-Serverless-Python3.11"
            }),
            status_code=200,
            mimetype="application/json"
        )
    else:
        return func.HttpResponse(
            json.dumps({"error": "Please pass a valid JSON event body"}),
            status_code=400,
            mimetype="application/json"
        )
