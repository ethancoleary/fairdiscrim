from otree.api import *


doc = """
Your app description
"""


class C(BaseConstants):
    NAME_IN_URL = 'task'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1
    CORRECT_ANSWERS = [200, 4, 500, 200, 2, 3]


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    investment = models.IntegerField(min=0,max=200)
    check1 = models.IntegerField()
    check2 = models.IntegerField(
        choices=[
            [1, '1/6'],
            [2, '1/3'],
            [3, '1/2'],
            [4, '2/3'],
            [5, '5/6']
        ]
    )
    check3 = models.IntegerField()
    check4 = models.IntegerField()
    check5 = models.IntegerField(
        choices=[
            [1, 'You can give some tokens to individual A and individual B.'],
            [2, 'You can give 300 tokens to either individual A or individual B.'],
            [3, 'You can give 300 tokens to either individual A, individual B or individual C.']
        ]
    )
    check6 = models.IntegerField(
        choices=[
            [1, 'You will earn 50% of the bonus payment pot of your chosen individual.'],
            [2, 'You will earn 1 token for every token invested by your chosen individual.'],
            [3, 'You will earn 1 token for every 5 tokens invested by your chosen individual.']
        ]
    )
    task = models.IntegerField(
        choices=[
            [1, 'Individual A'],
            [2, 'Individual B']
        ]
    )
    incorrect1 = models.IntegerField(initial=0)
    incorrect2 = models.IntegerField(initial=0)
    incorrect3 = models.IntegerField(initial=0)
    incorrect4 = models.IntegerField(initial=0)
    incorrect5 = models.IntegerField(initial=0)
    incorrect6 = models.IntegerField(initial=0)


# PAGES
class TaskIntro1(Page):
    pass

class TaskIntro2(Page):
    pass

class CompCheck(Page):
    form_model = 'player'
    form_fields = ['check1', 'check2', 'check3', 'check4', 'check5', 'check6']

    @staticmethod
    def error_message(player, values):
        if values['check1'] != C.CORRECT_ANSWERS[0]:
            player.incorrect1 = 1
            return ('Your answer to question 1 is wrong. The participants were given 200 tokens at first.')

        elif values['check2'] != C.CORRECT_ANSWERS[1]:
            player.incorrect2 = 1
            return (
                'Your answer to question 2 is wrong. The lottery was unsuccessful with a probability of 2/3.')

        elif values['check3'] != C.CORRECT_ANSWERS[2]:
            player.incorrect3 = 1
            return (
                'Your answer to question 3 is wrong. The lottery returned 2.5 the investment if successful. 2.5 x 200 = 500.')

        elif values['check4'] != C.CORRECT_ANSWERS[3]:
            player.incorrect4 = 1
            return (
                'Your answer to question 4 is wrong. If the investment was 0, the bonus pot contained 200 tokens.')

        elif values['check5'] != C.CORRECT_ANSWERS[4]:
            player.incorrect5 = 1
            return (
                'Your answer to question 5 is wrong. There are two individuals and you can give 300 tokens to one and 0 to the other.')

        elif values['check6'] != C.CORRECT_ANSWERS[5]:
            player.incorrect6 = 1
            return (
                'Your answer to question 6 is wrong. You earn 1 cent for every 5 tokens invested.')


class Task(Page):
    form_model = 'player'
    form_fields = ['investment']

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant
        participant.investment = player.investment



page_sequence = [
                TaskIntro1,
                TaskIntro2,
                CompCheck,
                Task
                ]
