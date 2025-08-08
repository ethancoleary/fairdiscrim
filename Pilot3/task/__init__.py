from otree.api import *
import random
import math

doc = """
Your app description
"""


class C(BaseConstants):
    NAME_IN_URL = 'task'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1
    CORRECT_ANSWERS = [300, 2, 2, 3]


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    investment300 = models.IntegerField(min=0,max=300)
    investment100 = models.IntegerField(min=0, max=100)
    check1 = models.IntegerField()
    check2 = models.IntegerField(
        choices=[
            [1, '1/6'],
            [2, '1/3'],
            [3, '1/2'],
            [4, '2/3'],
            [5, '5/6']
        ],
        widget=widgets.RadioSelect
    )
    check3 = models.IntegerField(
        choices = [
            [1, 'Either you or your partner is chosen at random to receive 300 tokens. The other receives 100 tokens.'],
            [2, 'A painting is chosen at random and the individual who chose that painting receives 300 tokens. The other receives 100 tokens.'],
            [3, 'An algorithm uses data from previous investment decisions of individuals from Group A and Group B to decide on the most profitable allocation.'],
            [4, 'A real participant uses data from previous investment decisions of individuals from Group A and Group B to decide on the most profitable allocation.']
        ],
        widget=widgets.RadioSelect
    )
    check4 = models.IntegerField(
        choices= [
            [1, 'It will be added to your investment budget in the form of 50 tokens.'],
            [2, 'It will be locked and paid out as an extra participation fee.'],
            [3, 'It may be affected by later decisions and then paid out as an extra participation fee.']
        ],
        widget=widgets.RadioSelect
    )

    treatment = models.IntegerField(initial=1) #Treatment 1 is random, 2 is computer discrim and 3 is human discrim.
    pilottreatment = models.IntegerField()
    computer = models.IntegerField()
    chosen = models.IntegerField(initial=0)
    incorrect1 = models.IntegerField(initial=0)
    incorrect2 = models.IntegerField(initial=0)
    incorrect3 = models.IntegerField(initial=0)
    incorrect4 = models.IntegerField(initial=0)
    incorrect5 = models.IntegerField(initial=0)
    incorrect6 = models.IntegerField(initial=0)
    transfer = models.IntegerField(initial=0)


# PAGES
class TaskIntro1(Page):
    pass

class TaskIntro2(Page):

    @staticmethod
    def vars_for_template(player):
        participant = player.participant
        player.pilottreatment = random.randint(1,4)

        participant.pilottreatment = player.pilottreatment
        participant.treatment = player.treatment

    @staticmethod
    def before_next_page(player, timeout_happened):
        if player.treatment == 1:
            player.computer = random.randint(1, 2)

        if player.computer == 1:
            if player.participant.group == 1:
                player.chosen = 1
            elif player.participant.group == 2:
                player.chosen = 0
        else:
            if player.participant.group == 1:
                player.chosen = 0
            elif player.participant.group == 2:
                player.chosen = 1

        player.participant.receive = player.chosen



class CompCheck(Page):
    form_model = 'player'
    form_fields = ['check1', 'check2', 'check3', 'check4']

    @staticmethod
    def error_message(player, values):
        if values['check1'] != C.CORRECT_ANSWERS[0]:
            player.incorrect1 = 1
            return ('Your answer to question 1 is wrong. One of you or your match will receive 300 tokens and the other 100.')

        elif values['check2'] != C.CORRECT_ANSWERS[1]:
            player.incorrect2 = 1
            return (
                'Your answer to question 2 is wrong. The lottery is successful with a probability of 1/3.')

        elif values['check3'] != C.CORRECT_ANSWERS[2]:
            player.incorrect3 = 1
            return (
                'Your answer to question 3 is wrong. One painting is chosen at random and the individual who chose that painting gets the higher investment budget.')

        elif values['check4'] != C.CORRECT_ANSWERS[3]:
            player.incorrect4 = 1
            return (
                'Your answer to question 4 is wrong. The amount is added to the participation fee but may be affected by later decisions.')


class TaskIntro3(Page):

    @staticmethod
    def vars_for_template(player):

        if player.computer == 1:
            chosen = "A"
        else:
            chosen = "B"

        if player.participant.group == 1:
            yourpainting = "A"
            partnerpainting = "B"
        else:
            yourpainting = "B"
            partnerpainting = "A"

        if player.chosen == 1:
            yourbudget = "300"
            partnerbudget = "100"
        else:
            yourbudget = "100"
            partnerbudget = "300"

        return {
            'chosen': chosen,
            'yourpainting': yourpainting,
            'partnerpainting': partnerpainting,
            'yourbudget': yourbudget,
            'partnerbudget': partnerbudget
        }


class Decision(Page):
    form_model = 'player'
    form_fields = ['transfer']

    @staticmethod
    def is_displayed(player):
        return player.chosen == 0

    @staticmethod
    def before_next_page(player):
        player.participant.steal = player.transfer

class InvestmentDecision300(Page):
    form_model = 'player'
    form_fields = ['investment300']

    @staticmethod
    def is_displayed(player):
        return player.chosen == 1

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant
        die = random.randint(1, 6)
        participant.die = die
        participant.investment = player.investment300

class InvestmentDecision100(Page):
    form_model = 'player'
    form_fields = ['investment100']

    @staticmethod
    def is_displayed(player):
        return player.chosen == 0

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant
        die = random.randint(1, 6)
        participant.die = die
        participant.investment = player.investment100


page_sequence = [
                TaskIntro1,
                TaskIntro2,
                CompCheck,
                TaskIntro3,
                Decision,
                InvestmentDecision300,
                InvestmentDecision100
                ]
