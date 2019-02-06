require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  let(:user){ create( :user ) }
  let!(:appointment){ create( :appointment ) }

  context 'For the guest of the system' do
    describe 'POST #create' do
      context 'with valid attributes' do
        it 'don\'t save new appointment in database' do
          expect { post :create, params: { appointment: attributes_for(:appointment) } }.to_not change(Appointment, :count)
        end

        it 'redirect to log in' do
          post :create, params: { appointment: attributes_for(:appointment) }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'don\'t save new appointment in database' do
          expect { post :create, params: { appointment: attributes_for(:appointment_invalid) } }.to_not change(Appointment, :count)
        end

        it 'redirect to log in' do
          post :create, params: { appointment: attributes_for(:appointment_invalid) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        before { patch :update, params: { id: appointment } }

        it 'redirect to log in' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'don\'t delete appointment' do
        expect { delete :destroy  , params: { id: appointment} }.to_not change(Appointment, :count)
      end

      it 'redirect to log in' do
        delete :destroy, params: { id: appointment}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'For the registered user of the system' do
    before { sign_in(appointment.user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'save new appointment in database' do
          expect { post :create, params: { appointment: attributes_for(:appointment) } }.to change(appointment.user.appointments, :count).by(1)
        end

        it 'redirect to appointments_path' do
          post :create, params: { appointment: attributes_for(:appointment) }
          expect(response).to redirect_to appointments_path
        end
      end

      context 'with invalid attributes' do
        it 'doesn\'t save the appointment' do
          expect { post :create, params: { appointment: { title: 'New title' }, user_id: appointment.user } }.to_not change(Appointment, :count)
        end
      end
    end
  end

  context 'The registered user is NOT the author of the appointment', %q{
    If User not the author of the appointment
    He should be forbidden access to update, destroy
  } do
    before { sign_in(user) }

    describe 'PATCH #update' do
      context 'with valid attributes' do
        before { patch :update, params: { id: appointment } }

        it 'don\'t update appointment' do
          expect(appointment.state).to eq 'pending'
        end

        it 'redirect to the appointments_path' do
          expect(response).to redirect_to appointments_path
        end
      end
    end

    describe 'DELETE #appointment' do
      before { patch :destroy, params: { id: appointment } }

      it 'delete appointment' do
        expect(appointment.state).to eq 'pending'
      end

      it 'redirect to the appointments_path' do
        expect(response).to redirect_to appointments_path
      end
    end
  end

  context 'The registered user is the author of the appointment', %q{
    If User the author of the appointment
    He can update, destroy
  } do
    before { sign_in(appointment.user) }

    describe 'PATCH ' do
      context 'with valid attributes' do
        before { patch :update, params: { id: appointment } }

        it 'confirmed appointment' do
          appointment.reload
          expect(appointment.state).to eq 'confirmed'
        end

        it 'redirect to the appointments_path' do
          expect(response).to redirect_to appointments_path
        end
      end
    end

    describe 'DELETE #destroy' do
      before { patch :destroy, params: { id: appointment } }

      it 'appointment' do
        appointment.reload
        expect(appointment.state).to eq 'canceled'
      end

      it 'redirect to the appointments_path' do
        expect(response).to redirect_to appointments_path
      end
    end
  end
end
