import datetime
import logging
import azure.functions as func
import storage_writer.logic as logic


def main(mytimer: func.TimerRequest) -> None:
    utc_timestamp = datetime.datetime.utcnow().replace(
        tzinfo=datetime.timezone.utc).isoformat()

    if mytimer.past_due:
        logging.info('The timer is past due!')

    logging.info('Python timer trigger function ran at %s', utc_timestamp)
    try:
        logic.storage_writer()
    except Exception as e:
        logging.error('Error:')
        logging.error(e)