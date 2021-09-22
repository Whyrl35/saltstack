from salt.utils.decorators.jinja import jinja_filter
import logging
import random

log = logging.getLogger(__name__)

@jinja_filter('shuffle')
def shuffle(obj, seed=None):
    try:
        if seed:
            random.seed(seed)
        random.shuffle(obj)
        return obj
    except Exception:
        log.exception("Failed to shuffle object '%s'", obj)
    return '[]'
