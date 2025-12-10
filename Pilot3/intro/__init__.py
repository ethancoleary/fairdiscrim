from otree.api import *
import random


doc = """
Stage 1 Pilot
"""


class C(BaseConstants):
    NAME_IN_URL = 'intro'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1
    MAX_KLEE_TREAT = 0
    MAX_KANDINSKY_TREAT = 100


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    consent = models.IntegerField(initial=0)
    gender = models.IntegerField(
        choices=[
            [1, 'Female'],
            [2, 'Male'],
            [3, 'Other'],
            [4, 'Prefer not to say']
        ],
        widget=widgets.RadioSelect
    )
    age = models.IntegerField(min=0, max=100)
    KK = models.IntegerField(
        choices=[
            [1, 'Klee'],
            [2, 'Kandinsky'],
        ],
    )
    accepted = models.IntegerField()
    treatment = models.IntegerField(initial=1)  # Treatment 1 is random, 2 is computer discrim and 3 is human discrim.
    die = models.IntegerField()
    invest = models.IntegerField()
    earnings = models.IntegerField()
    lottery = models.IntegerField()



# PAGES
class Intro(Page):
    form_model = 'player'
    form_fields = ['consent']

    @staticmethod
    def error_message(player, values):
        solutions = dict(consent=1)
        if values != solutions:
            return "Please consent to participation or withdraw from the experiment by closing your browser."


class PDetails(Page):
    form_model = 'player'
    form_fields = ['gender', 'age']

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant

        if player.gender == 2:
            participant.male = 1
            participant.group = 1
        else:
            participant.male = 0
            participant.group = 2



        if player.gender > 2:
            player.accepted = 0
        else:
            player.accepted = 1

class KK(Page):
    form_model = 'player'
    form_fields = ['KK']

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant
        participant.group = player.KK
        if player.gender == 1:
            participant.female = 1
        else:
            participant.female = 0

        all_players = player.subsession.get_players()
        admitted_klee = len([p for p in all_players if p.field_maybe_none('KK') == 1])

        admitted_kand = len([p for p in all_players if p.field_maybe_none('KK') == 2])

        remaining_spaces_klee = C.MAX_KLEE_TREAT - admitted_klee
        remaining_spaces_kand = C.MAX_KANDINSKY_TREAT - admitted_kand

        if player.KK == 1 and remaining_spaces_klee >= 0:
            player.accepted = 1
        elif player.KK == 2 and remaining_spaces_kand >= 0:
            player.accepted = 1
        else:
            player.accepted = 0

class InvestIntro(Page):

    @staticmethod
    def is_displayed(player):
        return player.accepted == 0

class Invest(Page):
    form_model = 'player'
    form_fields = ['invest']

    @staticmethod
    def is_displayed(player):
        return player.accepted == 0

    @staticmethod
    def before_next_page(player, timeout_happened):
        die = random.randint(1, 6)
        player.die = die

        if die < 3:
            player.lottery = 1
            player.earnings = 2.5 * player.invest + (200 - player.invest)
        elif die > 2:
            player.lottery = 0
            player.earnings = (200 - player.invest)

class Screen(Page):

    @staticmethod
    def vars_for_template(player):
        kept = 200 - player.invest
        if player.earnings % 10 == 0:
            bonus = f"{player.earnings / 100}0"
        else:
            bonus = f"{player.earnings / 100}"

        return {
            'kept': kept,
            'bonus': bonus
        }


    @staticmethod
    def is_displayed(player):
        return player.accepted == 0

class Redirect(Page):

    @staticmethod
    def is_displayed(player):
        return player.accepted == 0

    @staticmethod
    def js_vars(player):
        return dict(
            completionlinkscreenout=
            player.subsession.session.config['completionlinkscreenout']
        )



page_sequence = [
                Intro,
                PDetails,
                 #KK,
                InvestIntro,
                Invest,
                Screen,
                Redirect
                ]
